const express = require("express");
const path = require("path");
const app = express();
const session = require("express-session");
const bodyParser = require("body-parser");
const bcrypt = require("bcrypt");
const multer = require("multer");
const sharp = require("sharp");
const teacherFunctions = require("./external/teacherFunctions");
const conection = require("./config/db");
const pdf = require("html-pdf");
const ejs = require("ejs");
const cron = require("node-cron");

const dump = require("mysqldump");

// Obtain the name of the file
const storage = multer.diskStorage({
    filename: (req, file, cb) => {
        cb(null, file.originalname);
    },
});

// create an historial for DB versions
// cron.schedule("0 */3 * * *", () => {
//     // “At minute 0 past every 3rd hour.”
//     let x = new Date().toLocaleString().split("/").join("-");
//     x = x.split(" ").join("-");
//     x = x.split(":").join("-");
//     dump({
//         connection: {
//             host: "localhost",
//             user: "root",
//             password: "",
//             database: "saraswatidb",
//         },

//         dumpToFile: `./DB/saraswatidb-${x}.sql`,
//         timezone: "America/Argentina/Cordoba:180",
//     });
// });

// create an historial for DB versions in Github
// cron.schedule("0 0 1 1-12 *", () => {
//     // At 00:00 on day-of-month 1 in every month from January through December.
//     let x = new Date().toLocaleString().split("/").join("-");
//     x = x.split(" ").join("-");
//     x = x.split(":").join("-");
//     dump({
//         connection: {
//             host: "localhost",
//             user: "root",
//             password: "",
//             database: "saraswatidb",
//         },

//         dumpToFile: `./DB/saraswatidb-${x}.sql`,
//         timezone: "America/Argentina/Cordoba:180",
//     });
// });

// Upload contains storage and verify that the storage content comes from the formImagen.ejs file, limits its upload to 1 MB and that it is the appropriate format
var uploads = multer({
    storage: storage,
    limits: { fileSize: 1 * 1024 * 1024 },
    fileFilter: (req, file, cb) => {
        if (path.extname(file.originalname) !== ".png" && path.extname(file.originalname) !== ".jpg" && path.extname(file.originalname) !== ".gif" && path.extname(file.originalname) !== ".jpeg") {
            cb(new Error("goes wrong on the mimetype!"), false);
        } else {
            cb(null, true);
        }
    },
}).single("document");

const storageAprendizajes = multer.diskStorage({
    filename: (req, file, cb) => {
        cb(null, file.originalname);
    },
});

var aprendizajesExcel = multer({
    storage: storageAprendizajes,
    fileFilter: (req, file, cb) => {
        if (path.extname(file.originalname) == ".xlsx") {
            cb(null, true);
        } else if (path.extname(file.originalname) == ".txt") {
            cb(null, true);
        }
    },
}).single("learnings");

// Parse application/x-www-form-urlencoded
app.use(
    bodyParser.urlencoded({
        extended: false,
    })
);

app.use(express.static(path.join(__dirname, "public")));

// Bootstrap requirements
app.use("/css", express.static(__dirname + "/node_modules/bootstrap/dist/css"));
app.use("/js", express.static(__dirname + "/node_modules/jquery/dist"));
app.use("/js", express.static(__dirname + "/node_modules/popper.js/dist"));
app.use("/js", express.static(__dirname + "/node_modules/bootstrap/dist/js"));

app.use(
    session({
        secret: "secret",
        resave: true,
        saveUninitialized: true,
        logged: false,
    })
);

// Global variables
app.use((req, res, next) => {
    res.locals.rol = req.session.rol;
    res.locals.username = req.session.username;
    res.locals.toastrFlag = req.session.toastrFlag;
    res.locals.routeAvatar = req.session.routeAvatar;
    res.locals.inspirationalPhrase = req.session.inspirationalPhrase;
    res.locals.logged = req.session.logged;
    next();
});
var urlencodedParser = bodyParser.urlencoded({
    extended: false,
});

var con = conection.connection();

// Settings
app.set("views", __dirname + "/views");
app.set("view engine", "ejs");
// End Settings

// Routes
app.get("/", (req, res) => {
    req.session.logged = false;
    res.render("login.ejs");
});

app.get("/dashboard", (req, res) => {
    if (req.session.logged) {
        let rol = res.locals.rol;
        let username = res.locals.username;
        var auxData = [];

        for (let i = 0; i < rol.length; i++) {
            if (rol[i] == "administrador") {
                console.log("soy administrador");
            }
            if (rol[i] == "preceptor") {
                // async function getSubjects() {
                //     let query = "SELECT * FROM materia INNER JOIN profesor ON materia.profesor_usuario = profesor.nombreUsuario AND ? = materia.profesor_usuario";
                //     return new Promise((resolve, reject) => {
                //         con.query(query, [username], (error, rows) => {
                //             return resolve(rows);
                //         });
                //     });
                // }
                // auxData.push(getSubjects());
                console.log("soy preceptor");
            }
            if (rol[i] == "profesor") {
                async function getSubjects() {
                    let query = "SELECT * FROM materia INNER JOIN profesor ON materia.profesor_usuario = profesor.nombreUsuario AND ? = materia.profesor_usuario";
                    return new Promise((resolve, reject) => {
                        con.query(query, [username], (error, rows) => {
                            return resolve(rows);
                        });
                    });
                }
                auxData.push(getSubjects());
            }
            if (rol[i] == "estudiante") {
                console.log("soy estudiante");
            }
        }

        async function sequentialQueries() {
            try {
                const result = await Promise.all(auxData);

                res.render("dashboard.ejs", {
                    title: "InfoUser",
                    data: result,
                });
            } catch (error) {
                console.log(error);
            }
        }

        sequentialQueries();
    } else {
        res.redirect("/");
    }
});

app.get("/formularioImagen", (req, res) => {
    if (req.session.logged) {
        res.render("formularioImagen.ejs");
    } else {
        res.redirect("/");
    }
});

app.get("/logout", (req, res) => {
    req.session.destroy();
    res.redirect("/");
});

app.get("/agregarProfesor", (req, res) => {
    let rol = res.locals.rol;
    let flagRol;
    if (!req.session.logged) {
        res.redirect("/");
    } else {
        flagRol = false;
        for (let i = 0; i < rol.length; i++) {
            if (rol[i] == "preceptor") {
                flagRol = true;
            }
        }
    }
    if (flagRol) {
        let query = "SELECT * FROM materia WHERE profesor_usuario = ? ";
        con.query(query, ["lmazzola"], (error, rows, fields) => {
            res.render("addTeacher.ejs", {
                title: "Materias",
                data: rows,
            });
        });
    } else {
        res.redirect("/dashboard");
    }
});

app.get("/agregarUsuario", (req, res) => {
    let rol = res.locals.rol;
    for (let i = 0; i < rol.length; i++) {
        if (req.session.logged) {
            if (rol[i] == "administrador") {
                res.render("addUser.ejs");
            } else {
                res.redirect("/dashboard");
            }
        } else {
            res.redirect("/");
        }
    }
});

app.get("/agregarMateria", (req, res) => {
    let rol = res.locals.rol;
    if (!req.session.logged) {
        res.redirect("/");
    } else {
        let flagRol = false;
        for (let i = 0; i < rol.length; i++) {
            if (rol[i] == "preceptor") {
                flagRol = true;
            }
        }
        if (flagRol) {
            let query = "SELECT usuario FROM profesor";
            con.query(query, (error, rows, fields) => {
                res.render("addSubject.ejs", {
                    title: "Teachers",
                    data: rows,
                });
            });
        } else {
            res.redirect("/dashboard");
        }
    }
});

app.get("/agregarPreceptor", (req, res) => {
    let rol = res.locals.rol;
    for (let i = 0; i < rol.length; i++) {
        if (req.session.logged) {
            if (rol[i] == "administrador") {
                res.render("addPreceptor.ejs");
            } else {
                res.redirect("/dashboard");
            }
        } else {
            res.redirect("/");
        }
    }
});

app.get("/datatable", (req, res) => {
    if (req.session.logged) {
        res.render("datatable.ejs");
    } else {
        res.redirect("/");
    }
});

app.get("/cargarVistaEstudiante", (req, res) => {
    if (req.session.logged) {
        let username = res.locals.username;
        let query = "SELECT * FROM estudiante INNER JOIN materia ON materia.curso_descripcion = estudiante.descripcion_curso AND materia.profesor_usuario = ?";
        let cursos = [];
        con.query(query, [username], (error, rows, fields) => {
            if (error) throw error;
            for (let index = 0; index < rows.length; index++) {
                if (!cursos.includes(rows[index].curso_descripcion)) {
                    cursos.push(rows[index].curso_descripcion);
                }
            }
            res.render("allStudents.ejs", {
                title: "Student",
                data: rows,
                data2: cursos,
            });
        });
    } else {
        res.redirect("/");
    }
});

app.get("/agregarEstudiante", (req, res) => {
    let rol = res.locals.rol;
    let flagRol;
    if (!req.session.logged) {
        res.redirect("/");
    } else {
        flagRol = false;
        for (let i = 0; i < rol.length; i++) {
            if (rol[i] == "preceptor") {
                flagRol = true;
            }
        }
    }
    if (flagRol) {
        res.render("addStudent.ejs");
    } else {
        res.redirect("/dashboard");
    }
});

app.get("/listarProfesores", (req, res) => {
    if (req.session.logged) {
        let query = "SELECT * FROM profesor";
        con.query(query, (error, rows, fields) => {
            if (error) throw error;
            res.render("listTeacher.ejs", {
                title: "Profesores",
                data: rows,
            });
        });
    } else {
        res.redirect("/");
    }
});

app.get("/listarUsuarios", (req, res) => {
    if (req.session.logged) {
        let query = "SELECT * FROM usuario, materia";
        con.query(query, (error, rows, fields) => {
            if (error) throw error;
            res.render("listUser.ejs", {
                title: "Usuario",
                data: rows,
            });
        });
    } else {
        res.redirect("/");
    }
});

app.get("/miPerfil", (req, res) => {
    let rol = res.locals.rol;
    let username = res.locals.username;
    var auxData = [];
    if (req.session.logged) {
        async function infoProfile() {
            let query = "SELECT * FROM usuario WHERE usuario.nombreUsuario = ?";
            return new Promise((resolve, reject) => {
                con.query(query, [username], (error, rows) => {
                    return resolve(rows);
                });
            });
        }
        auxData.push(infoProfile());

        for (let i = 0; i < rol.length; i++) {
            if (rol[i] == "administrador") {
                // async function infoProfile() {
                //     let query = "SELECT * FROM admin";
                //     return new Promise((resolve, reject) => {
                //         con.query(query, [username], (error, rows) => {
                //             return resolve(rows);
                //         });
                //     });
                // }
                // auxData.push(infoProfile());
                console.log("soy administrador");
            }
            if (rol[i] == "preceptor") {
                // async function infoProfile() {
                //     let query = "SELECT * FROM materia INNER JOIN profesor ON materia.profesor_usuario = profesor.nombreUsuario AND ? = materia.profesor_usuario";
                //     return new Promise((resolve, reject) => {
                //         con.query(query, [username], (error, rows) => {
                //             return resolve(rows);
                //         });
                //     });
                // }
                // auxData.push(infoProfile());
                console.log("soy preceptor");
            }
            if (rol[i] == "profesor") {
                async function infoProfile() {
                    let query = "SELECT * FROM profesor WHERE nombreUsuario = ?";
                    return new Promise((resolve, reject) => {
                        con.query(query, [username], (error, rows) => {
                            return resolve(rows);
                        });
                    });
                }
                auxData.push(infoProfile());
            }
            if (rol[i] == "estudiante") {
                // async function infoProfile() {
                //     let query = "SELECT * FROM estudiate";
                //     return new Promise((resolve, reject) => {
                //         con.query(query, [username], (error, rows) => {
                //             return resolve(rows);
                //         });
                //     });
                // }
                // auxData.push(infoProfile());
                console.log("soy estudiante");
            }
        }
        async function sequentialQueries() {
            try {
                const result = await Promise.all(auxData);
                res.render("myProfile.ejs", {
                    title: "Profile",
                    data: result,
                });
            } catch (error) {
                console.log(error);
            }
        }
        sequentialQueries();
    } else {
        res.redirect("/");
    }
});

app.get("/obtenerAprendizajes", (req, res) => {
    if (req.session.logged) {
        let query = "SELECT * FROM estudianteaprendizaje WHERE estudianteaprendizaje.estudiante_dni = ?";
        con.query(query, [req.query.dni], (error, rows, fields) => {
            if (error) throw error;
            res.send(rows);
        });
    } else {
        res.redirect("/");
    }
});

app.get("/guardarAprendizajes", (req, res) => {
    let query = "UPDATE estudianteaprendizaje SET estado = ? WHERE estudianteaprendizaje.descripcion = ? AND estudianteaprendizaje.estudiante_dni = ?";
    let dni = 0;
    for (let key in req.query.data) {
        if (key == "dni") {
            dni = req.query.data[key];
        } else {
            for (let i = 0; i < req.query.data[key].length; i++) {
                con.query(query, [key, req.query.data[key][i].name, dni], (error, rows, fields) => {
                    if (error) throw error;
                });
            }
        }
    }

    res.send("");
});

app.get("/agregarAprendizajes", (req, res) => {
    if (req.session.logged) {
        // Create the learning in the learning table
        // (Positions) 0 = name L / 1 = period Name / 2 = subj id / 3 = subj name / 4 = course
        let idPeriod = 1;
        if (req.query.newLearningData[1] == "1er cuatrimestre") {
            idPeriod = 1;
        } else {
            idPeriod = 2;
        }
        let query1 = "INSERT INTO aprendizajes (descripcion,id_materia,id_periodo) VALUES (?, ?, ?)";
        con.query(query1, [req.query.newLearningData[0], req.query.newLearningData[2], idPeriod], (error, rows, fields) => {
            if (error) throw error;
        });
        // Search for the IDs of all students in this subject
        let query2 = "SELECT dni FROM estudiante WHERE descripcion_curso = ?";
        con.query(query2, [req.query.newLearningData[4]], (error, rows, fields) => {
            if (error) throw error;
            // With a for I create each learning for each student
            for (let i = 0; i < rows.length; i++) {
                let query3 = "INSERT INTO estudianteaprendizaje (descripcion,estado,estudiante_dni,periodo_id,materia_id) VALUES (?,?,?,?,?)";
                con.query(query3, [req.query.newLearningData[0], "pendiente", rows[i].dni, idPeriod, req.query.newLearningData[2]], (error, rows, fields) => {
                    if (error) throw error;
                });
            }
        });

        res.send("");
    } else {
        res.redirect("/");
    }
});

app.get("/borrarAprendizajes", (req, res) => {
    if (req.session.logged) {
        let query1 = "DELETE FROM aprendizajes WHERE descripcion = ?";
        let query2 = "DELETE FROM estudianteaprendizaje WHERE descripcion = ?";
        for (let i = 0; i < req.query.data.length; i++) {
            con.query(query1, [req.query.data[i]], (error, rows, fields) => {
                if (error) throw error;
            });

            con.query(query2, [req.query.data[i]], (error, rows, fields) => {
                if (error) throw error;
            });
        }

        res.send("");
    } else {
        res.redirect("/");
    }
});

app.get("/generarReporte/:dni", (req, res) => {
    if (req.session.logged) {
        console.log(req.params.dni); // result: test
        let dni = req.params.dni;
        let materia = req.body.materia;
        console.log(req.body.idSubject);

        let query1 = "SELECT * FROM estudiante WHERE dni = ?";
        let query2 ="SELECT * FROM materia INNER JOIN nota ON id_materia = ?";
        con.query(query1, [dni], (error, rows, fields) => {
            con.query(query2, [materia], (error, rows, fields) => { 
            if (error) throw error;
            console.log(rows);

            ejs.renderFile("views/GenerateReport.ejs", { name: rows }, (err, html) => {
                if (err) throw err;
                const options = {
                    format: "A4",
                    border: {
                        right: "8",
                    },
                };

                pdf.create(html, options).toFile("uploads/report.pdf", (err, res) => {
                    if (err) {
                        res.send(err);
                    } else {
                        console.log("Pdf creado");
                    }
                });
                res.type("pdf");
                res.download("uploads/report.pdf");
            });
        });

    // } else {
    //     res.redirect("/");
    // }
});
    
    };

});

app.get("/cambiarEstadoToastr", (req, res) => {
    res.locals.toastrFlag = false;
    req.session.toastrFlag = false;
    res.send(res.locals.toastrFlag);
});

app.get("/estadoToastr", (req, res) => {
    res.send(res.locals.toastrFlag);
});

app.get("/generarImagen", (req, res) => {
    let query = "SELECT * FROM usuario WHERE usuario.nombreUsuario = ?";
    con.query(query, [res.locals.username], (error, rows) => {
        res.render("changePassword.ejs", {
            title: "User",
            data: rows,
        });
    });
});

app.get("/crearSlider", (req, res) => {
    res.render("generarSlider.ejs");
});

app.get("/estadisticasEstudiante", (req, res) => {
    if (req.session.logged) {
        res.render("studentStadistics.ejs");
    } else {
        res.redirect("/");
    }
});

app.get("/obtenerEstadisiticasEstudiates", (req, res) => {
    let arr = {};
    // let query = "SELECT nombreMateria, curso_descripcion FROM materia WHERE profesor_usuario = ?";
    let query = "SELECT * FROM estudiante INNER JOIN materia ON profesor_usuario = ? AND materia.curso_descripcion = estudiante.descripcion_curso INNER JOIN nota ON nota.dni_alumno = estudiante.dni AND nota.id_materia = materia.id";
    con.query(query, [res.locals.username], (error, rows, fields) => {
        if (error) throw error;
        for (let i = 0; i < rows.length; i++) {
            let aux = rows[i]["descripcion_curso"].toString();
            if (Object.keys(arr).includes(aux)) {
                arr[aux].push({
                    subject: rows[i].nombreMateria,
                    subjectId: rows[i].id_materia,
                    dni: rows[i].dni,
                    nombre: rows[i].nombre,
                    apellido: rows[i].apellido,
                    notas: [rows[i].nota1, rows[i].nota2, rows[i].nota3, rows[i].nota4, rows[i].nota5, rows[i].nota6, rows[i].nota7, rows[i].nota8, rows[i].nota_definitiva],
                });
            } else {
                arr[aux] = [
                    {
                        subject: rows[i].nombreMateria,
                        subjectId: rows[i].id,
                        dni: rows[i].dni,
                        nombre: rows[i].nombre,
                        apellido: rows[i].apellido,
                        notas: [rows[i].nota1, rows[i].nota2, rows[i].nota3, rows[i].nota4, rows[i].nota5, rows[i].nota6, rows[i].nota7, rows[i].nota8, rows[i].nota_definitiva],
                    },
                ];
            }
        }
        res.send(arr);
    });
});

// Post
app.post("/changeInfoProfile", (req, res) => {
    let infoToChange = JSON.parse(req.body.info);
    let rol = res.locals.rol;
    let username = res.locals.username;

    for (let i = 0; i < rol.length; i++) {
        for (const key in infoToChange) {
            let query = `UPDATE ${rol[i]} SET ${key} = ? WHERE nombreUsuario = ?`;
            con.query(query, [infoToChange[key], username], (error, rows, fields) => {
                if (error) throw error;
            });
        }
    }

    res.json("infoUpdated");
});

app.post("/changeNumbersNotes", (req, res) => {
    let infoToChange = JSON.parse(req.body.info);
    for (let i = 0; i < infoToChange["data"].length; i++) {
        let aux = infoToChange["data"][i]["namefield"];
        let query = `UPDATE nota SET ${aux} = ? WHERE dni_alumno = ? AND id_materia = ?`;
        con.query(query, [infoToChange["data"][i]["value"], infoToChange["data"][i]["dni"], infoToChange["data"][i]["idSubject"]], (error, rows, fields) => {
            if (error) throw error;
        });
    }
    res.json("infoUpdated");
});

// Returns all students of the selected subject
app.post("/estudianteMateria", (req, res) => {
    let subjectName = req.body.subjectName;
    let query = "SELECT * FROM estudiante INNER JOIN materia ON materia.nombreMateria = ? AND materia.curso_descripcion = estudiante.descripcion_curso INNER JOIN nota ON nota.dni_alumno = estudiante.dni AND nota.id_materia  = materia.id";
    con.query(query, [subjectName, subjectName], (error, rows, fields) => {
        if (error) throw error;
        res.render("listStudent.ejs", {
            title: "Student",
            data: rows,
        });
    });
});

// Resize avatar images
app.post("/subirFotos", (req, res) => {
    uploads(req, res, function (err) {
        // FILE SIZE ERROR
        if (err instanceof multer.MulterError) {
            return res.json("overToSize");
        }

        // INVALID FILE TYPE, message will return from fileFilter callback
        else if (err) {
            return res.json("invalidType");
        }

        // SUCCESS
        else {
            function getFileExtension(filename) {
                return /[.]/.exec(filename) ? /[^.]+$/.exec(filename)[0] : undefined;
            }

            let width = 800;
            let heigth = 600;

            let usuario = res.locals.username;
            let extension = getFileExtension(req.file.originalname);

            sharp(req.file.path)
                .resize(width, heigth)
                .toFile("public/images/upload/avatars/avatar_" + usuario + "." + extension, (err) => {
                    if (!err) {
                        let img = "avatar_" + usuario + "." + extension;
                        let query = "UPDATE usuario SET avatar = ? WHERE nombreUsuario = ?";
                        con.query(query, [img, usuario], (errs, result) => {
                            if (errs) throw errs;
                            res.locals.routeAvatar = img;
                            req.session.routeAvatar = img;
                            res.json("updatedAvatar");
                        });
                    }
                });
        }
    });
});

// Create subject
app.post("/crearMateria", (req, res) => {
    if (req.session.logged) {
        let name = req.body.name;
        let image = req.body.image;
        let teachingHours = req.body.teachingHours;
        let teacherUser = req.body.teacherUser;

        let query = "INSERT INTO materia (nombre,imagen,horasCatedra,profesor_usuario) VALUES (?,?,?,?);";
        con.query(query, [name, image, teachingHours, teacherUser], (error, rows, fields) => {
            if (error) throw error;
            res.redirect("/dashboard");
        });
    } else {
        res.redirect("/");
    }
});

app.post("/cargarAprendizaje", aprendizajesExcel, (req, res, next) => {
    if (req.session.logged) {
        let trimester = req.body.quarter;
        let idSubject = req.body.idSubject;
        let file = req.body.file;

        //teacherFunctions.loadLearnings(req.file.path, con, typeOFile, trimester, idSubject);
        res.redirect("/dashboard");
    } else {
        res.redirect("/");
    }
});

app.post("/changePassword", (req, res) => {
    let salt = 10;
    let newPass = req.body.pass;

    let query = "SELECT pass FROM usuario WHERE nombreUsuario = ?";
    con.query(query, [res.locals.username], (error, rows, fields) => {
        if (error) throw error;
        bcrypt.compare(newPass, rows[0]["pass"], (err, row) => {
            if (!row) {
                let query = "UPDATE usuario SET pass = ?, contraseña_cambiada = 'true' WHERE nombreUsuario = ?";
                bcrypt.hash(newPass, salt, (err, encrypted) => {
                    newPass = encrypted;
                    con.query(query, [newPass, res.locals.username], (error, rows, fields) => {
                        if (error) throw error;
                        res.json("passwordChanged");
                    });
                });
            } else {
                res.json("passwordNotChanged");
            }
        });
    });
});

app.post("/agregar", (req, res) => {
    if (req.session.logged) {
        function generatePassword(length) {
            let pass = "";
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
            for (i = 0; i < length; i++) {
                pass += characters.charAt(Math.floor(Math.random() * characters.length));
            }
            return pass;
        }

        let nickname = req.body.nickname;
        let firstname = req.body.firstname;
        let lastname = req.body.lastname;
        let email = req.body.email;
        let Ingreso = req.body.Ingreso;
        let fecha_nacimiento = req.body.fecha_nacimiento;
        let dni = req.body.dni;
        let telefono = req.body.telefono;
        let genero = req.body.genero;
        let Estado = req.body.Estado;
        let password = generatePassword(12);
        let nombre = "profesor";
        let salt = 10; // Standar value

        bcrypt.hash(password, salt, (err, encrypted) => {
            password = encrypted;
            let userquery = "INSERT INTO usuario (nombreUsuario,pass,avatar, contraseña_cambiada) VALUE (?,?,?,?)";
            con.query(userquery, [nickname, password, "0", false], (error, rows, fields) => {
                if (error) throw error;
                let rolquery = "INSERT INTO rol(nombre,nombreUsuario) VALUE(?,?)";
                con.query(rolquery, [nombre, nickname], (error, rows, fields) => {
                    if (error) throw error;
                    let profequery = "INSERT INTO profesor (nombreUsuario,nombre, apellido,dni,telefono,email,genero,nacimiento,ingreso,estado) VALUES (?,?,?,?,?,?,?,?,?,?)";
                    con.query(profequery, [nickname, firstname, lastname, dni, telefono, email, genero, fecha_nacimiento, Ingreso, Estado], (error, rows, fields) => {
                        if (error) throw error;
                        res.redirect("/dashboard");
                    });
                });
            });
        });
    } else {
        res.redirect("/");
    }
});

//I compare the password entered to the one encrypted in the DB to be able to access the dashboard
app.post("/login", (req, res) => {
    let username = req.body.user;
    let password = req.body.pass;
    let query = "SELECT * FROM usuario WHERE nombreUsuario = ?";
    con.query(query, [username], (error, rows, fields) => {
        if (rows.length > 0) {
            bcrypt.compare(password, rows[0]["pass"], (err, row) => {
                if (row) {
                    res.locals.username = username;
                    req.session.username = username;
                    req.session.logged = true;

                    if (rows[0]["contraseña_cambiada"] === "true") {
                        res.locals.logged = true;
                        req.session.logged = true;

                        res.locals.routeAvatar = rows[0]["avatar"];
                        req.session.routeAvatar = rows[0]["avatar"];

                        let query2 = "SELECT nombre FROM rol INNER JOIN usuario ON ? = rol.nombreUsuario AND rol.nombreUsuario = usuario.nombreUsuario ";
                        con.query(query2, [username], (error, rows, fields) => {
                            let arrRol = [];
                            for (let i = 0; i < rows.length; i++) {
                                arrRol.push(rows[i].nombre);
                            }

                            res.locals.rol = arrRol;
                            req.session.rol = arrRol;

                            res.locals.toastrFlag = true;
                            req.session.toastrFlag = true;

                            let query3 = "SELECT frase,autor FROM frasesinspiradoras";
                            con.query(query3, (error, rows, fields) => {
                                i = Math.floor(Math.random() * rows.length);
                                aux = rows[i]["autor"].replace(/\b\w/g, (l) => l.toUpperCase());
                                res.locals.inspirationalPhrase = [rows[i]["frase"], aux, rows[i]["frase"].length];
                                req.session.inspirationalPhrase = [rows[i]["frase"], aux, rows[i]["frase"].length];
                                res.json("loginOk");
                            });
                        });
                    } else {
                        res.json("changePassword");
                    }
                } else {
                    res.json("wrongPass");
                }
            });
        } else {
            res.json("userNotExist");
        }
    });
});

app.get("/noLogueado", (req, res) => {
    res.render("loggedOut.ejs");
});

app.use((req, res, next) => {
    res.status(404).render("404");
});

app.use(function (err, req, res, next) {
    console.error(err.stack);
    res.status(500).render("505");
});

// End routes
app.listen(2500, () => {
    console.log("El servidor corriendo en el puerto 2500");
});
