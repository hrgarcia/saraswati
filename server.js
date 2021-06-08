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

// Obtain the name of the file
const storage = multer.diskStorage({
    filename: (req, file, cb) => {
        cb(null, file.originalname);
    },
});

// Upload contains storage and verify that the storage content comes from the formImagen.ejs file, limits its upload to 1 MB and that it is the appropriate format
var uploads = multer({
    storage: storage,
    limits: { fileSize: 1 * 1024 * 1024 },
    fileFilter: (req, file, cb) => {
        if (path.extname(file.originalname) !== ".png" && path.extname(file.originalname) !== ".jpg" && path.extname(file.originalname) !== ".gif" && path.extname(file.originalname) !== ".jpeg") {
            console.log("no es una imagen");
        } else {
            cb(null, true);
        }
    },
}).single("avatar");

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
    })
);

// Global variables
app.use((req, res, next) => {
    res.locals.rol = req.session.rol;
    res.locals.username = req.session.username;
    res.locals.toastrFlag = req.session.toastrFlag;
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
    res.render("login.ejs");
});

app.get("/dashboard", (req, res) => {
    if (req.session.loggedin) {
        let rol = res.locals.rol;
        let username = res.locals.username;
        var auxData = [];

        for (let i = 0; i < rol.length; i++) {
            if (rol[i] == "administrador") {
                console.log("soy administrador");
                // let query = "SELECT * FROM ?? INNER JOIN administrador ON materia. = administrador.usuario AND ? = materia.";
                // con.query(query, [username], (error, rows, fields) => {
                //     if (error) throw error;
                //     auxData.push(rows)
                // });
            }
            if (rol[i] == "preceptor") {
                let query = "SELECT * FROM materia INNER JOIN profesor ON materia.profesor_usuario = profesor.nombreUsuario AND ? = materia.profesor_usuario";
                con.query(query, [username], (error, rows, fields) => {
                    if (error) throw error;
                    res.render("dashboard.ejs", {
                        title: "InfoUser",
                        data: rows,
                    });
                });
            }
            if (rol[i] == "profesor") {
                let query = "SELECT * FROM materia INNER JOIN profesor ON materia.profesor_usuario = profesor.nombreUsuario AND ? = materia.profesor_usuario";
                con.query(query, [username], (error, rows, fields) => {
                    if (error) throw error;
                    res.render("dashboard.ejs", {
                        title: "InfoUser",
                        data: rows,
                    });
                });
            }
            if (rol[i] == "estudiante") {
                console.log("soy estudiante");
                // let query = "SELECT * FROM estudiante WHERE nombreUsuario = ?";
                // con.query(query, [username], (error, rows, fields) => {
                //     if (error) throw error;
                //     // auxData.push(rows);
                // });
            }
        }
        // console.log(auxData);
        // res.render("dashboard.ejs", {
        //     title: "InfoUser",
        //     data: auxData,
        // });
    }
});

app.get("/formularioImagen", (req, res) => {
    res.render("formularioImagen.ejs");
});

app.get("/cargarAprendizajes", (req, res) => {
    res.render("loadLearning.ejs");
});

app.get("/logout", (req, res) => {
    req.session.destroy();
    res.redirect("/");
});

app.get("/agregarProfesor", (req, res) => {
    res.render("addTeacher.ejs");
});

app.get("/agregarUsuario", (req, res) => {
    res.render("addUser.ejs");
});

app.get("/agregarMateria", (req, res) => {
    let query = "SELECT usuario FROM profesor";
    con.query(query, (error, rows, fields) => {
        res.render("addSubject.ejs", {
            title: "Teachers",
            data: rows,
        });
    });
});

app.get("/agregarPreceptor", (req, res) => {
    res.render("addPreceptor.ejs");
});

app.get("/estadisticas", (req, res) => {
    res.render("statistics.ejs");
});

app.get("/datatable", (req, res) => {
    res.render("datatable.ejs");
});

app.get("/cargarVistaEstudiante", (req, res) => {
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
});

app.get("/agregarEstudiante", (req, res) => {
    res.render("addStudent.ejs");
});

app.get("/listarProfesores", (req, res) => {
    let query = "SELECT * FROM profesor";
    con.query(query, (error, rows, fields) => {
        if (error) throw error;
        res.render("listTeacher.ejs", {
            title: "Profesores",
            data: rows,
        });
    });
});

app.get("/listarUsuarios", (req, res) => {
    let query = "SELECT * FROM usuario, materia";
    con.query(query, (error, rows, fields) => {
        if (error) throw error;
        res.render("listUser.ejs", {
            title: "Usuario",
            data: rows,
        });
    });
});

app.get("/miPerfil", (req, res) => {
    let query = "SELECT * FROM usuario  WHERE usuario.nombreUsuario = ?";
    //tendria que cambiar la consula actual por la que le dejo a continuacion y borrar
    //los corchetes y el contenido de abajo

    //`SELECT * FROM usuario  JOIN ${res.locals.rol} ON ${res.locals.rol}.nombreUsuario = ${res.locals.username} AND usuario.nombreUsuario = ${res.locals.username}`
    con.query(query, [res.locals.username], (error, rows, fields) => {
        if (error) throw error;
        res.render("myProfile.ejs", {
            title: "Perfil",
            data: rows,
        });
    });
});

app.get("/obtenerAprendizajes", (req, res) => {
    let query = "SELECT * FROM estudianteaprendizaje WHERE estudianteaprendizaje.estudiante_dni = ?";
    con.query(query, [req.query.dni], (error, rows, fields) => {
        if (error) throw error;
        res.send(rows);
    });
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
});

app.get("/borrarAprendizajes", (req, res) => {
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
});

app.get("/cambiarEstadoToastr", (req, res) => {
    res.locals.toastrFlag = false;
    req.session.toastrFlag = false;
    res.send(res.locals.toastrFlag);
});

app.get("/estadoToastr", (req, res) => {
    res.send(res.locals.toastrFlag);
});

app.get("/editarPerfil", (req, res) => {
    let query = "SELECT * FROM usuario WHERE usuario.nombreUsuario = ? ";
    con.query(query, [res.locals.username], (error, rows, fields) => {
        if (error) throw error;
        res.render("edit.ejs", {
            title: "Perfil",
            data: rows,
        });
    });
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
app.post("/subirFotos", uploads, (req, res, next) => {
    let width = 800;
    let heigth = 600;

    sharp(req.file.path)
        .resize(width, heigth)
        .toFile("public/images/icons/avatar_" + req.file.originalname, (err) => {
            if (!err) {
                console.log("El archivo se subio correctamente");
                res.end();
            }
        });
});

// Create subject
app.post("/crearMateria", (req, res) => {
    let name = req.body.name;
    let image = req.body.image;
    let teachingHours = req.body.teachingHours;
    let teacherUser = req.body.teacherUser;

    let query = "INSERT INTO materia (nombre,imagen,horasCatedra,profesor_usuario) VALUES (?,?,?,?);";
    con.query(query, [name, image, teachingHours, teacherUser], (error, rows, fields) => {
        if (error) throw error;
        res.redirect("/dashboard");
    });
});

app.post("/crearProfesor", urlencodedParser, (req, res) => {
    // User Data
    let user = req.body.user;
    let avatar = req.body.avatar;
    let salt = 10; // Standar value

    // Teacher data
    let name = req.body.name;
    let lastName = req.body.lastName;
    let dni = req.body.dni;
    let telephone = req.body.telephone;
    let email = req.body.email;
    let gender = req.body.gender;
    let birth = req.body.birth;
    let entry = req.body.entry;
    let state = req.body.state;

    console.log("entre a la ruta");

    // let query = "INSERT INTO profesor (usuario,nombre,apellido,dni,telefono,email,genero,nacimiento,ingreso,estado) VALUES (?,?,?,?,?,?,?,?,?,?);";
    // con.query(query, [user, name, lastName, dni, telephone, email, gender, birth, entry, state], (error, rows, fields) => {
    //     if (error) throw error;
    // });

    // bcrypt.hash(req.body.password, salt, (err, encrypted) => {
    //     let password = encrypted;
    //     let query2 = "INSERT INTO usuario (nombreUsuario,pass,avatar) VALUES (?,?,?);";
    //     con.query(query2, [user, password, avatar], (error, rows, fields) => {
    //         if (error) throw error;
    //         res.render("dashboard.ejs");
    //     });
    // });
});

app.post("/cargarAprendizaje", aprendizajesExcel, (req, res, next) => {
    let trimester = req.body.quarter;
    let idSubject = req.body.idSubject;
    let file = req.body.file;
    console.log(trimester);
    console.log(file);
    console.log(idSubject);

    //teacherFunctions.loadLearnings(req.file.path, con, typeOFile, trimester, idSubject);
    res.redirect("/dashboard");
});

app.get("/GenerateReport", (req, res) => {
    ejs.renderFile("views/GenerateReport.ejs", { name: "Informes" }, (err, html) => {
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
                console.log("File created successfully");
            }
        });
        res.type("pdf");
        res.download("uploads/report.pdf");
    });
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
                    req.session.loggedin = true;
                    let query2 = "SELECT nombre FROM rol INNER JOIN usuario ON ? = rol.nombreUsuario AND rol.nombreUsuario = usuario.nombreUsuario ";
                    con.query(query2, [username], (error, rows, fields) => {
                        let arrRol = [];
                        for (let i = 0; i < rows.length; i++) {
                            arrRol.push(rows[i].nombre);
                        }

                        res.locals.rol = arrRol;
                        req.session.rol = arrRol;

                        res.locals.username = username;
                        req.session.username = username;

                        res.locals.toastrFlag = true;
                        req.session.toastrFlag = true;

                        res.json("loginOk");
                    });
                } else {
                    res.json("wrongPass");
                    // console.log("El usuario existe pero la contraseña es incorrecta");
                }
            });
        } else {
            res.json("userNotExist");
            // Toastr (wrong credentials)
        }
    });
});

app.use((req, res, next) => {
    res.status(404).render("404");
});

// End routes
app.listen(2500, () => {
    console.log("El servidor corriendo en el puerto 2500");
});
