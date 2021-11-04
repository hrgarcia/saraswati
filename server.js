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
const xlsx = require("xlsx-color");

const dump = require("mysqldump");
const { request } = require("http");

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
        extended: true,
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
    res.locals.notificaciones = req.session.notificaciones;
    res.locals.flagNotificaciones = req.session.flagNotificaciones;
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
    res.render("loguearse.ejs");
});

app.get("/panelDeInicio", (req, res) => {
    if (req.session.logged) {
        let rol = res.locals.rol;
        let username = res.locals.username;
        var auxData = [];
        let peticionNotificacion = [];

        res.locals.notificaciones = [];
        req.session.notificaciones = [];

        if (res.locals.flagNotificaciones) {
            if (rol[0] == "administrador") {
                async function obtenerNotificaciones() {
                    let query = "SELECT * FROM notificaciones";
                    return new Promise((resolve, reject) => {
                        con.query(query, (error, rows) => {
                            // return resolve(rows);
                            let x = rows.map((a) => {
                                a.tags = a.tags.split(/\s+/);
                                console.log(a);
                                return a;
                            });

                            return resolve(x);
                        });
                    });
                }
                peticionNotificacion.push(obtenerNotificaciones());
            } else {
                async function obtenerNotificaciones() {
                    let dia = new Date();
                    dia = dia.toLocaleString("es-AR").substring(0, 10).split("/").join("-");
                    let query = "SELECT * FROM notificaciones WHERE fechaLanzamiento = ?";
                    return new Promise((resolve, reject) => {
                        con.query(query, [dia], (error, rows) => {
                            return resolve(rows);
                        });
                    });
                }
                peticionNotificacion.push(obtenerNotificaciones());
            }
        }

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
                aux = await Promise.all(peticionNotificacion);
                if (res.locals.flagNotificaciones) {
                    res.locals.notificaciones = aux[0];
                    req.session.notificaciones = aux[0];
                }
                res.render("panelDeInicio.ejs", {
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

app.get("/desloguearse", (req, res) => {
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
        let query = "SELECT nombreMateria FROM materia WHERE profesor_usuario = ?";
        con.query(query, ["profeX"], (error, rows, fields) => {
            console.log(rows);
            res.render("agregarProfesor.ejs", {
                data: rows,
            });
        });
    } else {
        res.redirect("/panelDeInicio");
    }
});

app.get("/agregarUsuario", (req, res) => {
    let rol = res.locals.rol;
    for (let i = 0; i < rol.length; i++) {
        if (req.session.logged) {
            if (rol[i] == "administrador") {
                res.render("addUser.ejs");
            } else {
                res.redirect("/panelDeInicio");
            }
        } else {
            res.redirect("/");
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
                res.redirect("/panelDeInicio");
            }
        } else {
            res.redirect("/");
        }
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
        let cursos = ["primer año", "segundo año", "tercer año", "quinto año", "sexto año"];
        let query = "SELECT descripcion FROM curso";

        con.query(query, (error, rows, fields) => {
            let curso_db = [];
            for (let index = 0; index < rows.length; index++) {
                curso_db.push(rows[index].query);
            }

            let cursoEstudiante = cursos.filter((i) => !curso_db.includes(i));
            res.render("agregarEstudiante.ejs", {
                dataCurso: cursoEstudiante,
            });
        });
    } else {
        res.redirect("/panelDeInicio");
    }
});

app.get("/listarProfesores/:nombreUsuario", (req, res) => {
    if (req.session.logged) {
        let nombreUsuario = req.params.nombreUsuario;
        let query = "SELECT * FROM profesor INNER JOIN materia WHERE materia.profesorUsuario == ?";
        let query2 = "SELECT * FROM materia WHERE materia.profesorUsuario = profeX";
        con.query(query, (error, [nombreUsuario], rows, fields) => {
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

app.get("/listarEstudiante", (req, res) => {
    if (req.session.logged) {
        let query = "SELECT * FROM estudiante";
        con.query(query, (error, rows, fields) => {
            if (error) throw error;
            res.render("listarEstudiantes.ejs", {
                title: "Estudiantes",
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
                res.render("miPerfil.ejs", {
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
        let dni = req.params.dni;
        let nombreMateria = req.body.nombreMateria;
        let query1 = "SELECT * FROM estudiante WHERE dni = ?";
        let query2 = "SELECT nombreMateria, nota1, nota2, nota3, nota4, nota5, nota6, nota7, nota8 FROM materia INNER JOIN nota ON materia.id = nota.id_materia WHERE nota.dni_alumno = ?";
        let query3 = "SELECT periodo_id, descripcion, estado FROM estudianteaprendizaje WHERE estudiante_dni = ?";
        con.query(query1, [dni], (error, infoAlumno, fields) => {
            con.query(query2, [dni], (error, notasAlumno, fields) => {
                con.query(query3, [dni], (error, aprendizajeAlumno, fields) => {
                    if (error) throw error;
                    console.log(notasAlumno);
                    console.log(aprendizajeAlumno);

                    ejs.renderFile("views/GenerateReport.ejs", { datosAlumno: infoAlumno, dataNotas: notasAlumno, datosApren: aprendizajeAlumno }, (err, html) => {
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
        });
    }
});

app.get("/generarReporteExcel/:dni/:idMateria", (req, res) => {
    if (!req.session.logged) {
        res.redirect("/");
    } else {
        let rol = res.locals.rol;

        flagRol = false;
        for (let i = 0; i < rol.length; i++) {
            if (rol[i] == "profesor") {
                flagRol = true;
            }
        }
        if (flagRol) {
            let dni = req.params.dni;
            let idMateria = req.params.idMateria;

            // Hago dos consultas para sacar las notas y los aprendizajes de cierto alumno
            let query = "SELECT * FROM materia INNER JOIN nota ON materia.id = ? AND nota.dni_alumno = ? AND nota.id_materia = ? INNER JOIN estudiante ON dni = ?";
            con.query(query, [idMateria, dni, idMateria, dni], (error, notasAlumno, fields) => {
                if (error) throw error;
                notasAlumno = notasAlumno[0];
                let query2 = "SELECT * FROM estudianteaprendizaje WHERE estudiante_dni = ?";
                con.query(query2, [dni], (error, aprendizajesAlumno, fields) => {
                    if (error) throw error;

                    // Verifico de que ciclo es el estudiante
                    let ciclo;
                    if (notasAlumno.descripcion_curso == "cuarto año" || notasAlumno.descripcion_curso == "quinto año" || notasAlumno.descripcion_curso == "sexto año") {
                        ciclo = "ciclo orientado";
                    } else {
                        ciclo = "ciclo basico";
                    }

                    // Recorro las diferentes tipos de nota y dependiendo si es menor o mayor a 6 les coloco un color de referencia
                    for (let i = 1; i < 9; i++) {
                        if (parseInt(notasAlumno[`nota${i}`]) <= 6) {
                            notasAlumno[`nota${i}`] = [notasAlumno[`nota${i}`], "FF9966"];
                        } else {
                            notasAlumno[`nota${i}`] = [notasAlumno[`nota${i}`], "99FF66"];
                        }
                    }

                    if (notasAlumno["nota_definitiva1"] <= 6) {
                        notasAlumno["nota_definitiva1"] = [notasAlumno["nota_definitiva1"], "FF9966"];
                    } else {
                        notasAlumno["nota_definitiva1"] = [notasAlumno["nota_definitiva1"], "99FF66"];
                    }

                    if (notasAlumno["nota_definitiva2"] <= 6) {
                        notasAlumno["nota_definitiva2"] = [notasAlumno["nota_definitiva2"], "FF9966"];
                    } else {
                        notasAlumno["nota_definitiva2"] = [notasAlumno["nota_definitiva2"], "99FF66"];
                    }

                    // JSON hecho a mano, el cual, el excel interpreta y va rellenando segun las celdas
                    let aux = {
                        A1: { t: "s", v: notasAlumno.nombre, s: { font: { sz: 14, bold: true, color: "#FF00FF" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        B1: { t: "s", v: notasAlumno.apellido, s: { font: { sz: 14, bold: true, color: "#FF00FF" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        C1: { t: "s", v: "-", s: { font: { sz: 14, bold: true, color: "#FF00FF" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        D1: { t: "s", v: notasAlumno.nombreMateria, s: { font: { sz: 14, bold: true, color: "#FF00FF" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        E1: { t: "s", v: "-", s: { font: { sz: 14, bold: true, color: "#FF00FF" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        F1: { t: "s", v: notasAlumno.descripcion_curso, s: { font: { sz: 14, bold: true, color: "#FF00FF" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        G1: { t: "s", v: "-", s: { font: { sz: 14, bold: true, color: "#FF00FF" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        H1: { t: "s", v: ciclo, s: { font: { sz: 14, bold: true, color: "#FF00FF" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },

                        // Titulos
                        A3: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        B3: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        C3: { t: "s", v: "1er cuatrimestre", s: { font: { sz: 14, bold: true, color: "#FF00FF" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        D3: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        G3: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        H3: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        E3: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        J3: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        K3: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },

                        I3: { t: "s", v: "2er cuatrimestre", s: { font: { sz: 12, bold: true, color: "#FF00FF" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },

                        A4: { t: "s", v: "Nota 1", s: { font: { sz: 12, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        B4: { t: "s", v: "Nota 2", s: { font: { sz: 12, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        C4: { t: "s", v: "Nota 3", s: { font: { sz: 12, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        D4: { t: "s", v: "Nota 4", s: { font: { sz: 12, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        E4: { t: "s", v: "Nota definitiva", s: { font: { sz: 12, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        G4: { t: "s", v: "Nota 1", s: { font: { sz: 12, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        H4: { t: "s", v: "Nota 2", s: { font: { sz: 12, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        I4: { t: "s", v: "Nota 3", s: { font: { sz: 12, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        J4: { t: "s", v: "Nota 4", s: { font: { sz: 12, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        K4: { t: "s", v: "Nota definitiva", s: { font: { sz: 12, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },

                        // Notas del 1er cuatimestre
                        A5: { t: "s", v: notasAlumno.nota1[0], s: { fill: { patternType: "solid", fgColor: { rgb: `${notasAlumno.nota1[1]}` } }, alignment: { vertical: "center", horizontal: "center" } } },
                        B5: { t: "s", v: notasAlumno.nota2[0], s: { fill: { patternType: "solid", fgColor: { rgb: `${notasAlumno.nota2[1]}` } }, alignment: { vertical: "center", horizontal: "center" } } },
                        C5: { t: "s", v: notasAlumno.nota3[0], s: { fill: { patternType: "solid", fgColor: { rgb: `${notasAlumno.nota3[1]}` } }, alignment: { vertical: "center", horizontal: "center" } } },
                        D5: { t: "s", v: notasAlumno.nota4[0], s: { fill: { patternType: "solid", fgColor: { rgb: `${notasAlumno.nota4[1]}` } }, alignment: { vertical: "center", horizontal: "center" } } },
                        E5: { t: "s", v: notasAlumno.nota_definitiva1[0], s: { fill: { patternType: "solid", fgColor: { rgb: `${notasAlumno.nota_definitiva1[1]}` } }, alignment: { vertical: "center", horizontal: "center" } } },

                        // Notas del 2do cuatimestre
                        G5: { t: "s", v: notasAlumno.nota5[0], s: { fill: { patternType: "solid", fgColor: { rgb: `${notasAlumno.nota5[1]}` } }, alignment: { vertical: "center", horizontal: "center" } } },
                        H5: { t: "s", v: notasAlumno.nota6[0], s: { fill: { patternType: "solid", fgColor: { rgb: `${notasAlumno.nota6[1]}` } }, alignment: { vertical: "center", horizontal: "center" } } },
                        I5: { t: "s", v: notasAlumno.nota7[0], s: { fill: { patternType: "solid", fgColor: { rgb: `${notasAlumno.nota7[1]}` } }, alignment: { vertical: "center", horizontal: "center" } } },
                        J5: { t: "s", v: notasAlumno.nota8[0], s: { fill: { patternType: "solid", fgColor: { rgb: `${notasAlumno.nota8[1]}` } }, alignment: { vertical: "center", horizontal: "center" } } },
                        K5: { t: "s", v: notasAlumno.nota_definitiva2[0], s: { fill: { patternType: "solid", fgColor: { rgb: `${notasAlumno.nota_definitiva2[1]}` } }, alignment: { vertical: "center", horizontal: "center" } } },

                        A6: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        B6: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        C6: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        D6: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        E6: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },

                        G6: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        H6: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        I6: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        J6: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        K6: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },

                        // Aprendizajes
                        A7: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        B7: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        C7: { t: "s", v: "Aprendizajes", s: { font: { sz: 14, bold: true, color: "#FF00FF" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        D7: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        E7: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        G7: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        H7: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        I7: { t: "s", v: "Aprendizajes", s: { font: { sz: 14, bold: true, color: "#FF00FF" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        J7: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        K7: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" }, alignment: { vertical: "center", horizontal: "center" } } },

                        A8: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        B8: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        C8: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        D8: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        E8: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        G8: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        H8: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        I8: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        J8: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        K8: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },

                        A9: { t: "s", v: "Pendiente", s: { font: { sz: 14, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        B9: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "b7b7b7" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        C9: { t: "s", v: "Proceso", s: { font: { sz: 14, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        D9: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "b7b7b7" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        E9: { t: "s", v: "Aprobado", s: { font: { sz: 14, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        G9: { t: "s", v: "Pendiente", s: { font: { sz: 14, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        H9: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "b7b7b7" } } } },
                        I9: { t: "s", v: "Proceso", s: { font: { sz: 14, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                        J9: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "b7b7b7" } } } },
                        K9: { t: "s", v: "Aprobado", s: { font: { sz: 14, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                    };

                    // Relleno el excel con los aprendizajes en su respectivo estado
                    if (aprendizajesAlumno.length > 0) {
                        let alfabeto = "ABCDEFGHIJKLMNOPQRSTUVWXZ";
                        let cont1 = 0;
                        let cont2 = 0;
                        let indexInicio1 = alfabeto.indexOf("A");
                        let indexInicio2 = alfabeto.indexOf("G");
                        let flagTodoPendiente = false;
                        let flagTodoProceso = false;
                        let flagEntreFor = 0;

                        // Cada vez que coloco un aprendizaje en el excel lo elimino de mi lista
                        // Todo el proceso debe hacerse en 3 iteraciones, primero los ap pendientes, luego los ap en progreso y los ap logrados
                        while (aprendizajesAlumno.length > 0) {
                            let color;
                            if (flagEntreFor == 1) {
                                flagTodoPendiente = true;
                                cont1 = 0;
                                cont2 = 0;
                            } else if (flagEntreFor == 2) {
                                flagTodoProceso = true;
                                cont1 = 0;
                                cont2 = 0;
                            }
                            flagEntreFor++;
                            for (let i = aprendizajesAlumno.length - 1; i >= 0; i--) {
                                if (aprendizajesAlumno[i].estado == "pendiente") {
                                    if (cont1 % 2 == 0) {
                                        color = "ff9966";
                                    } else {
                                        color = "ff6d6d";
                                    }
                                    if (aprendizajesAlumno[i].periodo_id == 1) {
                                        aux[`${alfabeto[indexInicio1]}${10 + cont1}`] = {
                                            t: "s",
                                            v: aprendizajesAlumno[i].descripcion,
                                            s: { fill: { patternType: "solid", fgColor: { rgb: "FF9966" } }, alignment: { vertical: "center", horizontal: "center" } },
                                        };
                                        cont1++;
                                        aprendizajesAlumno.splice(i, 1);
                                    } else {
                                        aux[`${alfabeto[indexInicio2]}${10 + cont2}`] = {
                                            t: "s",
                                            v: aprendizajesAlumno[i].descripcion,
                                            s: { fill: { patternType: "solid", fgColor: { rgb: "FF9966" } }, alignment: { vertical: "center", horizontal: "center" } },
                                        };
                                        cont2++;
                                        aprendizajesAlumno.splice(i, 1);
                                    }
                                } else if (aprendizajesAlumno[i].estado == "proceso" && flagTodoPendiente) {
                                    if (cont1 % 2 == 0) {
                                        color = "ffff99";
                                    } else {
                                        color = "f2fa48";
                                    }
                                    if (aprendizajesAlumno[i].periodo_id == 1) {
                                        aux[`${alfabeto[indexInicio1 + 2]}${10 + cont1}`] = {
                                            t: "s",
                                            v: aprendizajesAlumno[i].descripcion,
                                            s: { fill: { patternType: "solid", fgColor: { rgb: color } }, alignment: { vertical: "center", horizontal: "center" } },
                                        };
                                        cont1++;
                                        aprendizajesAlumno.splice(i, 1);
                                    } else {
                                        aux[`${alfabeto[indexInicio2 + 2]}${10 + cont2}`] = {
                                            t: "s",
                                            v: aprendizajesAlumno[i].descripcion,
                                            s: { fill: { patternType: "solid", fgColor: { rgb: color } }, alignment: { vertical: "center", horizontal: "center" } },
                                        };
                                        cont2++;
                                        aprendizajesAlumno.splice(i, 1);
                                    }
                                } else if (aprendizajesAlumno[i].estado == "aprobado" && flagTodoProceso) {
                                    if (cont1 % 2 == 0) {
                                        color = "99ff66";
                                    } else {
                                        color = "c0ffa1";
                                    }
                                    if (aprendizajesAlumno[i].periodo_id == 1) {
                                        aux[`${alfabeto[indexInicio1 + 4]}${10 + cont1}`] = {
                                            t: "s",
                                            v: aprendizajesAlumno[i].descripcion,
                                            s: { fill: { patternType: "solid", fgColor: { rgb: color } }, alignment: { vertical: "center", horizontal: "center" } },
                                        };
                                        cont1++;
                                        aprendizajesAlumno.splice(i, 1);
                                    } else {
                                        aux[`${alfabeto[indexInicio2 + 4]}${10 + cont2}`] = {
                                            t: "s",
                                            v: aprendizajesAlumno[i].descripcion,
                                            s: { fill: { patternType: "solid", fgColor: { rgb: color } }, alignment: { vertical: "center", horizontal: "center" } },
                                        };
                                        cont2++;
                                        aprendizajesAlumno.splice(i, 1);
                                    }
                                }
                            }
                        }
                    }
                    aux["!ref"] = "A1:P60";

                    aux["!cols"] = [{ width: 20 }, { width: 20 }, { width: 20 }, { width: 20 }, { width: 20 }, { width: 20 }, { width: 20 }, { width: 20 }, { width: 20 }, { width: 20 }, { width: 20 }];
                    const wb = xlsx.utils.book_new();
                    xlsx.utils.book_append_sheet(wb, aux, "Notas");
                    // Hacer que se descargue donde lo eliga el usuario
                    xlsx.writeFile(wb, `notas_${notasAlumno.nombre}_${notasAlumno.apellido}.xlsx`);
                    res.json("");
                });
            });
        } else {
            res.redirect("/panelDeInicio");
        }
    }
});

app.get("/generarReporteExcelTodos/:idMateria", (req, res) => {
    if (!req.session.logged) {
        res.redirect("/");
    } else {
        let rol = res.locals.rol;

        flagRol = false;
        for (let i = 0; i < rol.length; i++) {
            if (rol[i] == "profesor") {
                flagRol = true;
            }
        }
        if (flagRol) {
            const wb = xlsx.utils.book_new();
            let idMateria = req.params.idMateria;
            let query =
                "SELECT dni, curso_descripcion FROM estudiante INNER JOIN materia ON materia.id = ? AND materia.curso_descripcion = estudiante.descripcion_curso INNER JOIN nota ON nota.dni_alumno = estudiante.dni AND nota.id_materia = materia.id";
            con.query(query, [idMateria], (error, dniAlumnos, fields) => {
                if (error) throw error;
                for (let i = 0; i < dniAlumnos.length; i++) {
                    let dni = dniAlumnos[i].dni;
                    let query2 = "SELECT * FROM materia INNER JOIN nota ON materia.id = ? AND nota.dni_alumno = ? AND nota.id_materia = ? INNER JOIN estudiante ON dni = ?";
                    con.query(query2, [idMateria, dni, idMateria, dni], (error, notasAlumno, fields) => {
                        if (error) throw error;
                        let query3 = "SELECT * FROM estudianteaprendizaje WHERE estudiante_dni = ?";
                        con.query(query3, [dni], (error, aprendizajesAlumno, fields) => {
                            notasAlumno = notasAlumno[0];

                            // Verifico de que ciclo es el estudiante
                            let ciclo;
                            if (notasAlumno.descripcion_curso == "cuarto año" || notasAlumno.descripcion_curso == "quinto año" || notasAlumno.descripcion_curso == "sexto año") {
                                ciclo = "ciclo orientado";
                            } else {
                                ciclo = "ciclo basico";
                            }

                            // Recorro las diferentes tipos de nota y dependiendo si es menor o mayor a 6 les coloco un color de referencia
                            for (let i = 1; i < 9; i++) {
                                if (parseInt(notasAlumno[`nota${i}`]) <= 6) {
                                    notasAlumno[`nota${i}`] = [notasAlumno[`nota${i}`], "FF9966"];
                                } else {
                                    notasAlumno[`nota${i}`] = [notasAlumno[`nota${i}`], "99FF66"];
                                }
                            }

                            if (notasAlumno["nota_definitiva1"] <= 6) {
                                notasAlumno["nota_definitiva1"] = [notasAlumno["nota_definitiva1"], "FF9966"];
                            } else {
                                notasAlumno["nota_definitiva1"] = [notasAlumno["nota_definitiva1"], "99FF66"];
                            }

                            if (notasAlumno["nota_definitiva2"] <= 6) {
                                notasAlumno["nota_definitiva2"] = [notasAlumno["nota_definitiva2"], "FF9966"];
                            } else {
                                notasAlumno["nota_definitiva2"] = [notasAlumno["nota_definitiva2"], "99FF66"];
                            }

                            // JSON hecho a mano, el cual, el excel interpreta y va rellenando segun las celdas
                            let aux = {
                                A1: { t: "s", v: notasAlumno.nombre, s: { font: { sz: 14, bold: true, color: "#FF00FF" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                B1: { t: "s", v: notasAlumno.apellido, s: { font: { sz: 14, bold: true, color: "#FF00FF" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                C1: { t: "s", v: "-", s: { font: { sz: 14, bold: true, color: "#FF00FF" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                D1: { t: "s", v: notasAlumno.nombreMateria, s: { font: { sz: 14, bold: true, color: "#FF00FF" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                E1: { t: "s", v: "-", s: { font: { sz: 14, bold: true, color: "#FF00FF" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                F1: {
                                    t: "s",
                                    v: notasAlumno.descripcion_curso,
                                    s: { font: { sz: 14, bold: true, color: "#FF00FF" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } },
                                },
                                G1: { t: "s", v: "-", s: { font: { sz: 14, bold: true, color: "#FF00FF" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                H1: { t: "s", v: ciclo, s: { font: { sz: 14, bold: true, color: "#FF00FF" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },

                                // Titulos
                                A3: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                B3: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                C3: { t: "s", v: "1er cuatrimestre", s: { font: { sz: 14, bold: true, color: "#FF00FF" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                D3: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                G3: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                H3: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                E3: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                J3: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                K3: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },

                                I3: { t: "s", v: "2er cuatrimestre", s: { font: { sz: 12, bold: true, color: "#FF00FF" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },

                                A4: { t: "s", v: "Nota 1", s: { font: { sz: 12, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                B4: { t: "s", v: "Nota 2", s: { font: { sz: 12, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                C4: { t: "s", v: "Nota 3", s: { font: { sz: 12, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                D4: { t: "s", v: "Nota 4", s: { font: { sz: 12, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                E4: { t: "s", v: "Nota definitiva", s: { font: { sz: 12, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                G4: { t: "s", v: "Nota 1", s: { font: { sz: 12, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                H4: { t: "s", v: "Nota 2", s: { font: { sz: 12, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                I4: { t: "s", v: "Nota 3", s: { font: { sz: 12, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                J4: { t: "s", v: "Nota 4", s: { font: { sz: 12, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                K4: { t: "s", v: "Nota definitiva", s: { font: { sz: 12, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },

                                // Notas del 1er cuatimestre
                                A5: { t: "s", v: notasAlumno.nota1[0], s: { fill: { patternType: "solid", fgColor: { rgb: `${notasAlumno.nota1[1]}` } }, alignment: { vertical: "center", horizontal: "center" } } },
                                B5: { t: "s", v: notasAlumno.nota2[0], s: { fill: { patternType: "solid", fgColor: { rgb: `${notasAlumno.nota2[1]}` } }, alignment: { vertical: "center", horizontal: "center" } } },
                                C5: { t: "s", v: notasAlumno.nota3[0], s: { fill: { patternType: "solid", fgColor: { rgb: `${notasAlumno.nota3[1]}` } }, alignment: { vertical: "center", horizontal: "center" } } },
                                D5: { t: "s", v: notasAlumno.nota4[0], s: { fill: { patternType: "solid", fgColor: { rgb: `${notasAlumno.nota4[1]}` } }, alignment: { vertical: "center", horizontal: "center" } } },
                                E5: { t: "s", v: notasAlumno.nota_definitiva1[0], s: { fill: { patternType: "solid", fgColor: { rgb: `${notasAlumno.nota_definitiva1[1]}` } }, alignment: { vertical: "center", horizontal: "center" } } },

                                // Notas del 2do cuatimestre
                                G5: { t: "s", v: notasAlumno.nota5[0], s: { fill: { patternType: "solid", fgColor: { rgb: `${notasAlumno.nota5[1]}` } }, alignment: { vertical: "center", horizontal: "center" } } },
                                H5: { t: "s", v: notasAlumno.nota6[0], s: { fill: { patternType: "solid", fgColor: { rgb: `${notasAlumno.nota6[1]}` } }, alignment: { vertical: "center", horizontal: "center" } } },
                                I5: { t: "s", v: notasAlumno.nota7[0], s: { fill: { patternType: "solid", fgColor: { rgb: `${notasAlumno.nota7[1]}` } }, alignment: { vertical: "center", horizontal: "center" } } },
                                J5: { t: "s", v: notasAlumno.nota8[0], s: { fill: { patternType: "solid", fgColor: { rgb: `${notasAlumno.nota8[1]}` } }, alignment: { vertical: "center", horizontal: "center" } } },
                                K5: { t: "s", v: notasAlumno.nota_definitiva2[0], s: { fill: { patternType: "solid", fgColor: { rgb: `${notasAlumno.nota_definitiva2[1]}` } }, alignment: { vertical: "center", horizontal: "center" } } },

                                A6: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                B6: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                C6: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                D6: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                E6: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },

                                G6: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                H6: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                I6: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                J6: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                K6: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },

                                // Aprendizajes
                                A7: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                B7: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                C7: { t: "s", v: "Aprendizajes", s: { font: { sz: 14, bold: true, color: "#FF00FF" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                D7: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                E7: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                G7: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                H7: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                I7: { t: "s", v: "Aprendizajes", s: { font: { sz: 14, bold: true, color: "#FF00FF" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                J7: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                K7: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" }, alignment: { vertical: "center", horizontal: "center" } } },

                                A8: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                B8: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                C8: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                D8: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                E8: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                G8: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                H8: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                I8: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                J8: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                K8: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },

                                A9: { t: "s", v: "Pendiente", s: { font: { sz: 14, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                B9: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "b7b7b7" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                C9: { t: "s", v: "Proceso", s: { font: { sz: 14, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                D9: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "b7b7b7" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                E9: { t: "s", v: "Aprobado", s: { font: { sz: 14, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                G9: { t: "s", v: "Pendiente", s: { font: { sz: 14, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                H9: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "b7b7b7" } } } },
                                I9: { t: "s", v: "Proceso", s: { font: { sz: 14, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                                J9: { t: "s", v: " ", s: { fill: { patternType: "solid", fgColor: { rgb: "b7b7b7" } } } },
                                K9: { t: "s", v: "Aprobado", s: { font: { sz: 14, bold: true, color: "#b7b7b7" }, fill: { patternType: "solid", fgColor: { rgb: "AEAAAA" } }, alignment: { vertical: "center", horizontal: "center" } } },
                            };

                            // Relleno el excel con los aprendizajes en su respectivo estado
                            if (aprendizajesAlumno.length > 0) {
                                let alfabeto = "ABCDEFGHIJKLMNOPQRSTUVWXZ";
                                let cont1 = 0;
                                let cont2 = 0;
                                let indexInicio1 = alfabeto.indexOf("A");
                                let indexInicio2 = alfabeto.indexOf("G");
                                let flagTodoPendiente = false;
                                let flagTodoProceso = false;
                                let flagEntreFor = 0;

                                // Cada vez que coloco un aprendizaje en el excel lo elimino de mi lista
                                // Todo el proceso debe hacerse en 3 iteraciones, primero los ap pendientes, luego los ap en progreso y los ap logrados
                                while (aprendizajesAlumno.length > 0) {
                                    let color;

                                    if (flagEntreFor == 1) {
                                        flagTodoPendiente = true;
                                        cont1 = 0;
                                        cont2 = 0;
                                    } else if (flagEntreFor == 2) {
                                        flagTodoProceso = true;
                                        cont1 = 0;
                                        cont2 = 0;
                                    }
                                    flagEntreFor++;
                                    for (let i = aprendizajesAlumno.length - 1; i >= 0; i--) {
                                        if (aprendizajesAlumno[i].estado == "pendiente") {
                                            if (cont1 % 2 == 0) {
                                                color = "ff9966";
                                            } else {
                                                color = "ff6d6d";
                                            }
                                            if (aprendizajesAlumno[i].periodo_id == 1) {
                                                aux[`${alfabeto[indexInicio1]}${10 + cont1}`] = {
                                                    t: "s",
                                                    v: aprendizajesAlumno[i].descripcion,
                                                    s: { fill: { patternType: "solid", fgColor: { rgb: color } }, alignment: { vertical: "center", horizontal: "center" } },
                                                };
                                                cont1++;
                                                aprendizajesAlumno.splice(i, 1);
                                            } else {
                                                aux[`${alfabeto[indexInicio2]}${10 + cont2}`] = {
                                                    t: "s",
                                                    v: aprendizajesAlumno[i].descripcion,
                                                    s: { fill: { patternType: "solid", fgColor: { rgb: color } }, alignment: { vertical: "center", horizontal: "center" } },
                                                };
                                                cont2++;
                                                aprendizajesAlumno.splice(i, 1);
                                            }
                                        } else if (aprendizajesAlumno[i].estado == "proceso" && flagTodoPendiente) {
                                            if (cont1 % 2 == 0) {
                                                color = "ffff99";
                                            } else {
                                                color = "f2fa48";
                                            }
                                            if (aprendizajesAlumno[i].periodo_id == 1) {
                                                aux[`${alfabeto[indexInicio1 + 2]}${10 + cont1}`] = {
                                                    t: "s",
                                                    v: aprendizajesAlumno[i].descripcion,
                                                    s: { fill: { patternType: "solid", fgColor: { rgb: color } }, alignment: { vertical: "center", horizontal: "center" } },
                                                };
                                                cont1++;
                                                aprendizajesAlumno.splice(i, 1);
                                            } else {
                                                aux[`${alfabeto[indexInicio2 + 2]}${10 + cont2}`] = {
                                                    t: "s",
                                                    v: aprendizajesAlumno[i].descripcion,
                                                    s: { fill: { patternType: "solid", fgColor: { rgb: color } }, alignment: { vertical: "center", horizontal: "center" } },
                                                };
                                                cont2++;
                                                aprendizajesAlumno.splice(i, 1);
                                            }
                                        } else if (aprendizajesAlumno[i].estado == "aprobado" && flagTodoProceso) {
                                            if (cont1 % 2 == 0) {
                                                color = "99ff66";
                                            } else {
                                                color = "c0ffa1";
                                            }
                                            if (aprendizajesAlumno[i].periodo_id == 1) {
                                                aux[`${alfabeto[indexInicio1 + 4]}${10 + cont1}`] = {
                                                    t: "s",
                                                    v: aprendizajesAlumno[i].descripcion,
                                                    s: { fill: { patternType: "solid", fgColor: { rgb: color } }, alignment: { vertical: "center", horizontal: "center" } },
                                                };
                                                cont1++;
                                                aprendizajesAlumno.splice(i, 1);
                                            } else {
                                                aux[`${alfabeto[indexInicio2 + 4]}${10 + cont2}`] = {
                                                    t: "s",
                                                    v: aprendizajesAlumno[i].descripcion,
                                                    s: { fill: { patternType: "solid", fgColor: { rgb: color } }, alignment: { vertical: "center", horizontal: "center" } },
                                                };
                                                cont2++;
                                                aprendizajesAlumno.splice(i, 1);
                                            }
                                        }
                                    }
                                }
                            }
                            aux["!ref"] = "A1:P60";

                            aux["!cols"] = [{ width: 20 }, { width: 20 }, { width: 20 }, { width: 20 }, { width: 20 }, { width: 20 }, { width: 20 }, { width: 20 }, { width: 20 }, { width: 20 }, { width: 20 }];
                            xlsx.utils.book_append_sheet(wb, aux, `${notasAlumno.nombre}_${notasAlumno.apellido}`);
                            if (dniAlumnos[i + 1] == undefined) {
                                xlsx.writeFile(wb, `notas_${dniAlumnos[0].curso_descripcion}.xlsx`);
                                res.json("");
                            }
                        });
                    });
                }
            });
        } else {
            res.redirect("/panelDeInicio");
        }
    }
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
        res.render("cambiarContraseña.ejs", {
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
        res.render("estadisticaEstudiante.ejs");
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
            // Agregar lo aprendizajes
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
app.post("/cambiarInfoPerfil", (req, res) => {
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

app.post("/cambiarNotas", (req, res) => {
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
    if (req.session.logged) {
        let subjectName = req.body.subjectName;
        let query = "SELECT * FROM estudiante INNER JOIN materia ON materia.nombreMateria = ? AND materia.curso_descripcion = estudiante.descripcion_curso INNER JOIN nota ON nota.dni_alumno = estudiante.dni AND nota.id_materia  = materia.id";
        con.query(query, [subjectName], (error, rows, fields) => {
            if (error) throw error;
            res.render("listaEstudianteMateria.ejs", {
                title: "Student",
                data: rows,
            });
        });
    } else {
        res.redirect("/");
    }
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
            res.redirect("/panelDeInicio");
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
        res.redirect("/panelDeInicio");
    } else {
        res.redirect("/");
    }
});

app.post("/cambiarClave", (req, res) => {
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
        let nickname = req.body.nickname.toLowerCase();
        let firstname = req.body.firstname.toLowerCase();
        let lastname = req.body.lastname.toLowerCase();
        let email = req.body.email.toLowerCase();
        let ingreso = req.body.ingreso.toLowerCase();
        let fecha_nacimiento = req.body.fecha_nacimiento.toLowerCase();
        let dni = req.body.dni.toLowerCase();
        let telefono = req.body.telefono;
        let genero = req.body.genero.toLowerCase();
        let estado = req.body.estado.toLowerCase();
        let password = "argentina2022";
        let nombre = "profesor";
        let salt = 10; // Standar value
        let nombreMateria = req.body.materias[0];
        nombreMateria = nombreMateria.toLowerCase();
        let nombreMateriaCarta = nombreMateria;
        nombreMateriaCarta = nombreMateriaCarta.split(" ").join("_");

        let horas_catedra = req.body.horas_catedra;
        let curso = req.body.curso.toLowerCase();
        let cursoImagenTexto = curso.split(" ").join("_");
        let imgMateria = `${cursoImagenTexto}/${nombreMateriaCarta}.jpg`;
        bcrypt.hash(password, salt, (err, encrypted) => {
            password = encrypted;
            let userquery = "INSERT INTO usuario (nombreUsuario,pass,avatar, contraseña_cambiada) VALUE (?,?,?,?)";
            con.query(userquery, [nickname, password, "0", false], (error, rows, fields) => {
                if (error) throw error;
                let rolquery = "INSERT INTO rol(nombre,nombreUsuario) VALUE(?,?)";
                con.query(rolquery, [nombre, nickname], (error, rows, fields) => {
                    if (error) throw error;
                    let profequery = "INSERT INTO profesor (nombreUsuario, nombre, apellido,dni, telefono, email, genero, nacimiento, ingreso, estado) VALUES (?,?,?,?,?,?,?,?,?,?)";
                    con.query(profequery, [nickname, firstname, lastname, dni, telefono, email, genero, fecha_nacimiento, ingreso, estado], (error, rows, fields) => {
                        // Crear las materias reales en la DB para que funcione todo bien
                        if (error) throw error;
                        let materiaQuery = "INSERT INTO materia(nombreMateria, imagen, horasCatedra, profesor_usuario, curso_descripcion) VALUES (?,?,?,?,?)";
                        con.query(materiaQuery, [nombreMateria, imgMateria, horas_catedra, nickname, curso], (error, rows, fields) => {
                            if (error) throw error;
                            res.redirect("/panelDeInicio");
                        });
                    });
                });
            });
        });
    } else {
        res.redirect("/");
    }
});

//I compare the password entered to the one encrypted in the DB to be able to access the panelDeInicio
app.post("/loguearse", (req, res) => {
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

                            res.locals.flagNotificaciones = false;
                            req.session.flagNotificaciones = false;

                            if (arrRol[0] == "administrador") {
                                let query = "SELECT * FROM notificaciones";
                                con.query(query, (error, rows) => {
                                    if (rows.length > 0) {
                                        res.locals.flagNotificaciones = true;
                                        req.session.flagNotificaciones = true;
                                        res.json("loginOk");
                                    } else {
                                        res.json("loginOk");
                                    }
                                });
                            } else {
                                dia = new Date();
                                dia = dia.toLocaleString("es-AR").substring(0, 10).split("/").join("-");
                                let query = "SELECT * FROM notificaciones WHERE fechaLanzamiento = ?";
                                con.query(query, [dia], (error, rows) => {
                                    if (rows.length > 0) {
                                        res.locals.flagNotificaciones = true;
                                        req.session.flagNotificaciones = true;
                                        res.json("loginOk");
                                    } else {
                                        res.json("loginOk");
                                    }
                                });
                            }
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

app.get("/crearNotificaciones", (req, res) => {
    if (!req.session.logged) {
        res.redirect("/");
    } else {
        let rol = res.locals.rol;

        flagRol = false;
        for (let i = 0; i < rol.length; i++) {
            if (rol[i] == "administrador") {
                flagRol = true;
            }
        }
        if (flagRol) {
            res.render("agregarNotificaciones.ejs");
        } else {
            res.redirect("/panelDeInicio");
        }
    }
});

app.post("/crearNotificaciones", (req, res) => {
    let titulo = req.body.titulo;
    let fechaEvento = req.body.fechaEvento;
    let fechaLanzamiento = req.body.fechaLanzamiento;
    let tags = req.body.tags;

    titulo = titulo.toLowerCase();
    tags = tags.toLowerCase();
    fechaEvento = fechaEvento.substring(8, 10) + "-" + fechaEvento.substring(5, 7) + "-" + fechaEvento.substring(0, 4);
    fechaLanzamiento = fechaLanzamiento.substring(8, 10) + "-" + fechaLanzamiento.substring(5, 7) + "-" + fechaLanzamiento.substring(0, 4);

    let dia = new Date();
    dia = dia.toLocaleString("es-AR").substring(0, 10).split("/").join("-");

    let querySelect = "SELECT count(*) FROM notificaciones";
    con.query(querySelect, (error, rows) => {
        console.log(rows[0]["count(*)"]);
        if (rows[0]["count(*)"] < 5) {
            if (fechaLanzamiento == dia) {
                res.locals.flagNotificaciones = true;
                req.session.flagNotificaciones = true;
            }
            let query = "INSERT INTO notificaciones (titulo,fechaEvento,fechaLanzamiento,tags) VALUES (?,?,?,?);";
            con.query(query, [titulo, fechaEvento, fechaLanzamiento, tags], (error, rows, fields) => {
                if (error) throw error;
                res.json("crearNotificacion");
            });
        } else {
            res.json("limiteAlcanzado");
        }
    });
});

app.post("/crearEstudiante", (req, res) => {
    if (req.session.logged) {
        let salt = 10; // Standar value
        let nickname = req.body.nickname;
        let firstname = req.body.firstname;
        let lastname = req.body.lastname;
        let password = "argentina2022";
        let email = req.body.email;
        let fecha_nacimiento = req.body.fecha_nacimiento;
        let dni = req.body.dni;
        let telefono = req.body.telefono;
        let genero = req.body.genero;
        let legajo = req.body.legajo;
        let descripcion_curso = req.body.descripcion_curso;
        let nombre = "estudiante";
        let nombreMateria = req.body.nombreMateria;
        let id = req.body.id;
        bcrypt.hash(password, salt, (err, encrypted) => {
            password = encrypted;
            let userquery = "INSERT INTO usuario (nombreUsuario, pass, avatar, contraseña_cambiada) VALUE (?,?,?,?)";
            con.query(userquery, [nickname, password, "avatarDefault.jpg", false], (error, rows, fields) => {
                if (error) throw error;
                let rolquery = "INSERT INTO rol (nombre, nombreUsuario) VALUE (?,?)";
                con.query(rolquery, [nombre, nickname], (error, rows, fields) => {
                    if (error) throw error;
                    let estudiantequery = "INSERT INTO estudiante (nombreUsuario, nombre, apellido, dni, telefono, email, genero, fecha_nacimiento,descripcion_curso,legajo) VALUES (?,?,?,?,?,?,?,?,?,?)";
                    con.query(estudiantequery, [nickname, firstname, lastname, dni, telefono, email, genero, fecha_nacimiento, descripcion_curso, legajo], (error, rows, fields) => {
                        if (error) throw error;
                        let materias = "SELECT id,nombreMateria FROM materia WHERE curso_descripcion = ?";
                        con.query(materias, [descripcion_curso], (error, rows, fields) => {
                            console.log(rows);
                            for (let i = 0; i < rows.length; i++) {
                                const notas_materias = rows[i];
                                let notaEstudianteperiodoUNO = "INSERT INTO nota (nota1, nota2, nota3, nota4, nota_definitiva1, descripcion_curso, dni_alumno) VALUES (?,?,?,?,?,?,?)";
                                con.query(notaEstudianteperiodoUNO, [0, 0, 0, 0, 0, descripcion_curso, dni], (error, rows, fields) => {
                                    if (error) throw error;
                                });
                            }
                        });
                        for (let i = 0; i < rows.length; i++) {
                            const notas_materiasdos = rows[i];
                            let notaEstudianteperiodoDOS = "INSERT INTO nota (nota5, nota6, nota7, nota8, nota_definitiva2, descripcion_curso, dni_alumno) VALUES (?,?,?,?,?,?,?)";
                            con.query(notaEstudianteperiodoDOS, [0, 0, 0, 0, 0, descripcion_curso, dni], (error, rows, fields) => {
                                if (error) throw error;
                                res.redirect("/panelDeInicio");
                            });
                        }
                    });
                });
            });
        });
    } else {
        res.redirect("/");
    }
});

app.get("/borrarNotificacion/:id", (req, res) => {
    let id = req.params.id;
    let query = "DELETE FROM notificaciones WHERE id = ?";
    con.query(query, [id], (error, rows, fields) => {
        if (error) throw error;
        res.json("");
    });
});

app.get("/borrarProfesor/:nombreUsuario", (req, res) => {
    let nombreUsuario = req.params.nombreUsuario;
    let query = "DELETE FROM profesor WHERE nombreUsuario = ?";
    con.query(query, [nombreUsuario], (error, rows, fields) => {
        if (error) throw error;
        let query2 = "DELETE FROM usuario WHERE nombreUsuario = ?";
        con.query(query2, [nombreUsuario], (error, rows, fields) => {
            if (error) throw error;
            res.redirect("/listarProfesor");
        });
    });
});

app.get("/noLogueado", (req, res) => {
    res.render("desloguearse.ejs");
});

app.use((req, res, next) => {
    res.status(404).render("404");
});

app.use(function (err, req, res, next) {
    console.error(err.stack);
    res.status(500).render("500");
});

// End routes
app.listen(2500, () => {
    console.log("El servidor corriendo en el puerto 2500");
});
