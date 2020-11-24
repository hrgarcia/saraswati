const express = require('express');
const path = require('path');
const app = express();
const session = require('express-session');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt');
const multer  = require('multer');
const sharp = require('sharp');
const teacherFunctions = require('./external/teacherFunctions');
const conection = require('./config/db');

// sirve para obtener el nombre del archivo
const storage = multer.diskStorage({

    filename: function(req, file, cb){
		cb(null, file.originalname);
	}});

// upload contiene storage y verifica que el contenido de storage venga del archivo formularioImagen.ejs, limita su subida a 1 MB y que sea el formato apropiado
var uploads = multer({
	storage : storage,
	limits: { fileSize: 1 * 1024 * 1024}, 
	fileFilter: function (req, file, cb) {
	if(path.extname(file.originalname) !== '.png' && path.extname(file.originalname) !== '.jpg' && path.extname(file.originalname) !== '.gif' && path.extname(file.originalname) !== '.jpeg') {
		console.log("no es una imagen");
	}
	else{
		cb(null, true);
	}

}}).single('avatar');

const storageAprendizajes = multer.diskStorage({

    filename: function(req, file, cb){
		cb(null, file.originalname);
	}});

// upload contiene storage y verifica que el contenido de storage venga del archivo formularioImagen.ejs, limita su subida a 1 MB y que sea el formato apropiado
var aprendizajesExcel = multer({
	storage : storageAprendizajes,
	fileFilter: function (req, file, cb) {
	if(path.extname(file.originalname) !== '.xlsx') {
		console.log("no es un excel");
	}
	else{
		cb(null, true);
	}

}}).single('aprendizajes');

// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({
	extended: false
}));

app.use(express.static(path.join(__dirname, 'public')));

//Bootstrap requirements
app.use('/css', express.static(__dirname + '/node_modules/bootstrap/dist/css'));
app.use('/js', express.static(__dirname + '/node_modules/jquery/dist'));
app.use('/js', express.static(__dirname + '/node_modules/popper.js/dist'));
app.use('/js', express.static(__dirname + '/node_modules/bootstrap/dist/js'));

app.use(session({
	secret: 'secret',
	resave: true,
	saveUninitialized: true
}));

//hacemos que la variable Rol sea global
app.use(function (req, res, next) {
	res.locals.rol = req.session.rol;
	res.locals.username = req.session.username;
	res.locals.toastrFlag = req.session.toastrFlag;
	next();
});
var urlencodedParser = bodyParser.urlencoded({
	extended: false
})

var con = conection.connection();

//Configuración
app.set('views', __dirname + '/views');
app.set('view engine', 'ejs');
//Fin configuración


//Rutas
app.get('/', (req, res) => {
	res.render('login.ejs');
});

app.get('/dashboard', (req, res) => {
	if (req.session.loggedin) {
		let query = "SELECT * FROM materia  INNER JOIN profesor ON materia.profesor_usuario = profesor.usuario AND ? = materia.profesor_usuario";
		con.query(query, [res.locals.username], function (error, rows, fields) {
			if (error) throw error;
			res.render('dashboard.ejs', {
				title: "Subjects",
				data: rows
			});
		});
	}
});

app.get('/formularioImagen', (req, res) => {
    res.render('formularioImagen.ejs');
});

app.get('/loadLearnings', (req, res) => {
    res.render('loadLearning.ejs');
});

app.get('/profile', (req, res) => {
	let query = "SELECT * FROM usuario";
	con.query(query, function (error, rows, fields){
		if (error) throw error;
			res.render('profile.ejs',{
				title: "Perfil",
				data: rows});
	});
});

app.get('/logout', (req, res) => {
	req.session.destroy();
	res.redirect('/');
});

app.get('/agregarProfesor', (req, res) => {
	res.render('addTeacher.ejs');
});

app.get('/agregarUsuario', (req, res) => {
	res.render('addUser.ejs');
});

app.get('/agregarMateria', (req, res) => {
	let query = "SELECT usuario FROM profesor";
	con.query(query, function (error, rows, fields) {
		res.render('addSubject.ejs', {
			title: "Teachers",
			data: rows
		});
	});
});

app.get('/agregarPreceptor', (req, res) => {
	res.render('addPreceptor.ejs');
});

app.get('/estadisticas', (req, res) => {
	res.render('statistics.ejs');
});

app.get('/datatable', (req, res) => {
	res.render('datatable.ejs');
});

app.get('/form', (req, res) => {
	res.render('form.ejs');
});

app.get('/listarProfesores', (req, res) => {
	let query = "SELECT * FROM profesor";
	con.query(query, function (error, rows, fields) {
		if (error) throw error;
		res.render('listTeacher.ejs', {
			title: "Profesores",
			data: rows
		});
	});
});

app.get('/listarUsuarios', (req, res) => {
	let query = "SELECT * FROM usuario, materia";
	con.query(query, function (error, rows, fields) {
		if (error) throw error;
		res.render('listUser.ejs', {
			title: "Usuario",
			data: rows
		});
	});
});

app.get('/myProfile', (req, res) => {
    let query = "SELECT * FROM usuario WHERE usuario.nombreUsuario = ? ";
    con.query(query, [res.locals.username] , function (error, rows, fields){
        if (error) throw error;
        res.render('myProfile.ejs',{
            title: "Perfil",
			data: rows
		});
	});	
});

app.get('/obtenerAprenzidajes', (req, res) => {
	let query = "SELECT * FROM estudianteaprendizaje WHERE estudianteaprendizaje.estudiante_dni = ?";
    con.query(query, [req.query.dni] , function (error, rows, fields){
		if (error) throw error;
		res.send(rows);
	});	
});
app.get('/guardarAprendizajes', (req, res) => {
	let query = "UPDATE estudianteaprendizaje SET estado = ? WHERE estudianteaprendizaje.descripcion = ? AND estudianteaprendizaje.estudiante_dni = ?";
	let dni=0;
	for(let key in req.query.data) {
		if(key == "dni"){
			dni = req.query.data[key];
		}
		else{
			for(let i = 0; i <req.query.data[key].length;i++){
				con.query(query, [key,req.query.data[key][i].name,dni], function (error, rows, fields){
				if (error) throw error;
				});	
			}
		}
	}
	res.send("");
	
});

app.get('/edit', (req, res) => {
    let query = "SELECT * FROM usuario WHERE usuario.nombreUsuario = ? ";
    con.query(query, [res.locals.username] , function (error, rows, fields){
        if (error) throw error;
        res.render('edit.ejs',{
            title: "Perfil",
			data: rows
		});
    });
});

//Devuelve todos los estudiante de la materia seleccionada
app.post('/estudianteMateria', (req, res) => {
    // Query para pasar los aprendizajes
    let learningRows;
    let queryLearning = "SELECT descripcion, id_materia FROM aprendizajes INNER JOIN materia ON  materia.id = aprendizajes.id_materia";
    con.query(queryLearning, [], function (error, rows, fields) {
        if (error) throw error;
        learningRows = rows;
    });

    let course = req.body.course;
    let query = "SELECT * FROM estudiante INNER JOIN materia ON materia.curso_descripcion = ? AND estudiante.descripcion_curso = ? ";
    con.query(query, [course,course], function (error, rows, fields) {
        if (error) throw error;
        res.render('listStudent.ejs', {
            title: "Student",
            data: rows,
            title: "Learnings",
            data2: learningRows
        });
    });
});

//Redimensionar las imágenes del avatar
app.post('/subirFotos', uploads, function(req, res, next){
    let width = 800;
    let heigth = 600;

    sharp(req.file.path)
    .resize(width, heigth)
    .toFile('public/images/icons/avatar_'+req.file.originalname, function (err) {
        if(!err) {
            console.log("El archivo se subio correctamente");
        res.end();
        }
    })
})

// Creación de materia
app.post('/crearMateria', (req, res) => {
	let name = req.body.name;
	let image = req.body.image;
	let teachingHours = req.body.teachingHours
	let teacherUser = req.body.teacherUser;

	let query = "INSERT INTO materia (nombre,imagen,horasCatedra,profesor_usuario) VALUES (?,?,?,?);"
	con.query(query,[name,image,teachingHours,teacherUser], function (error, rows, fields) {
		if (error) throw error;
		res.render('dashboard.ejs');	
	});
});

app.post('/crearProfesor', urlencodedParser, function (req, res) {
	//datos de usuario
	let user = req.body.user;
	let avatar = req.body.avatar;
	let salt = 10; //valor estandar

	//datos de profe
	let name = req.body.name;
	let lastName = req.body.lastName
	let dni = req.body.dni;
	let telephone = req.body.telephone;
	let email = req.body.email;
	let gender = req.body.gender;
	let birth = req.body.birth;
	let entry = req.body.entry;
	let state = req.body.state;

	let query = "INSERT INTO profesor (usuario,nombre,apellido,dni,telefono,email,genero,nacimiento,ingreso,estado) VALUES (?,?,?,?,?,?,?,?,?,?);";
	con.query(query, [user, name, lastName, dni, telephone, email, gender, birth, entry, state], function (error, rows, fields) {
		if (error) throw error;
	});

	bcrypt.hash(req.body.password, salt, (err, encrypted) => {
		let password = encrypted;
		let query2 = "INSERT INTO usuario (nombreUsuario,pass,avatar) VALUES (?,?,?);";
		con.query(query2, [user, password, avatar], function (error, rows, fields) {
			if (error) throw error;
			res.render('dashboard.ejs');
		});
	});
})

app.post('/loadLearning', aprendizajesExcel, function(req, res, next){
    teacherFunctions.loadLearnings(req.file.path, con);
});

app.post('/crearPreceptor', urlencodedParser, function (req, res) {
	//datos de usuario
	let user = req.body.user;
	let avatar = req.body.avatar;
	let salt = 10; //valor estandar

	//datos del preceptor
	let name = req.body.name;
	let lastName = req.body.lastName
	let dni = req.body.dni;
	let telephone = req.body.telephone;
	let email = req.body.email;
	let gender = req.body.gender;
	let birth = req.body.birth;
	let entry = req.body.entry;
	let state = req.body.state;

	bcrypt.hash(req.body.password, salt, (err, encrypted) => {
		let password = encrypted;
		let query2 = "INSERT INTO usuario (nombreUsuario,pass,avatar) VALUES (?,?,?);";
		con.query(query2, [user, password, avatar], function (error, rows, fields) {
			if (error) throw error;
			res.render('dashboard.ejs');
		});
	});
})

//Comparo la contraseña ingresada a la que esta encriptda en la DB para poder acceder al dashboard
app.post('/login', function (req, res) {
	let username = req.body.username;
	let password = req.body.password;

	if (username && password) {
		let query = 'SELECT * FROM usuario WHERE nombreUsuario = ?';
		con.query(query, [username], function (error, rows, fields) {
			if (rows.length > 0) {
				bcrypt.compare(password, rows[0]['pass'], function (err, row) {
					if (row) {
						req.session.loggedin = true; 
						let query2 = 'SELECT nombre FROM rol INNER JOIN usuario ON ? = rol.nombreUsuario AND rol.nombreUsuario = usuario.nombreUsuario ';
						con.query(query2,[username], function (error, rows, fields) {
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

							res.redirect('/dashboard');
						});
					}
				});
			}
			else{
				console.log("credenciales incorrectas");
				//aca iria el toastr (credenciales incorrectas)
			}
		});
	}
	else{
		console.log("ingresa lgo");
		//aca iria el toastr (si o si tenes que escribir un usuario y contraseña)
	}
});

app.use(function(req, res, next) {
	res.status(404).render('404');
});

//Fin Rutas
app.listen(2500, () => {
	console.log("El servidor corriendo en el puerto 2500");
});