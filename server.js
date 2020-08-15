const express = require('express');
const mysql = require('mysql');
const path = require('path');
const app = express();
const session = require('express-session');
const bodyParser = require('body-parser')
const bcrypt = require('bcrypt');
const toastr = require('toastr');

app.use(session({
	secret: 'secret',
	resave: true,
	saveUninitialized: true
}));


// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }));

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
app.use(function(req, res, next) {
	res.locals.rol = req.session.rol;
	next();
});
var urlencodedParser = bodyParser.urlencoded({ extended: false })

var con = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "saraswatidb"
});

con.connect(function(error){
	if(error) throw error;
	console.log("Conectado a la DB");
});

//Configuración
app.set('views', __dirname + '/views');
app.set('view engine','ejs');
//Fin configuración


//Rutas
app.get('/',(req,res) =>{
	res.render('login.ejs');
});

app.get('/dashboard',(req,res) =>{
	if(req.session.loggedin){
		res.render('dashboard.ejs');
	}
	//toast de que no te registraste
});

app.get('/logout',(req,res) =>{
	req.session.destroy();
	res.redirect('/');
});

app.get('/agregarProfesor',(req,res) =>{
	res.render('addTeacher.ejs');
});

app.get('/agregarUsuario',(req,res) =>{
	res.render('addUser.ejs');
});

app.get('/listarProfesores',(req,res) =>{
	let query = "SELECT * FROM profesor";
	con.query(query,function(error,rows,fields){
    if(error) throw error;
    res.render('listarProfesores.ejs',{title:"Profesores",datos:rows});
	});
});

app.get('/listarUsuarios',(req,res) =>{
	let query = "SELECT * FROM usuario";
	con.query(query,function(error,rows,fields){
    if(error) throw error;
    res.render('listarUsuarios.ejs',{title:"Usuario",datos:rows});
	});
});


app.post('/crearProfesor', urlencodedParser, function (req, res) {
	let user = req.body.user;
	let name = req.body.lastName;
	let dni = req.body.dni;
	let telephone = req.body.telephone;
	let email = req.body.email;
	let gender = req.body.gender;
	let birth = req.body.birth;
	let entry = req.body.entry;
	let state = req.body.state;
	
	let query = "INSERT INTO profesor (usuario,nombre,apellido,dni,telefono,email,genero,nacimiento,ingreso,estado) VALUES (?,?,?,?,?,?,?,?,?,?);";
	con.query(query,[user,name,lastName,dni,telephone,email,gender,birth,entry,state], function(error,rows,fields){
    if(error) throw error;
	res.render('dashboard.ejs');
	});
})


app.post('/crearUsuario', urlencodedParser, function (req, res) {
	let username = req.body.username;
	let name = req.body.name;
	let lastName = req.body.lastName;
	let avatar = req.body.avatar;

	let checks = [check1 = req.body.check1,
		check2 = req.body.check2,
		check3 = req.body.check3,
		check4 = req.body.check4];
	
	let rol ='';
	for (let i = 0; i < 4; i++) {
		if(checks[i] != undefined){
			rol += checks[i] + ',';
		}
	}

	let salt = 10; //valor aleatorio

	//agarro la password ingresada y le aplico la encriptacion, para luego subir eso a la DB
	bcrypt.hash(req.body.password, salt, (err, encrypted) => {
		let password = encrypted;
		let query = "INSERT INTO usuario (nombreUsuario,pass,nombre,apellido,rol,avatar) VALUES (?,?,?,?,?,?);";
		con.query(query,[username,password,name,lastName,rol,avatar], function(error,rows,fields){
		if(error) throw error;
		res.render('dashboard.ejs');
		});
	})
});

//Comparo la contraseña ingresada a la que esta encriptda en la DB para poder acceder al dashboard
app.post('/login', function(req, res){
	let username = req.body.username;
	let password = req.body.password;

	if(username && password){
		let query = 'SELECT * FROM usuario WHERE nombreUsuario = ?';
		con.query(query, [username], function(error, rows, fields) {
			if(rows.length > 0){
				bcrypt.compare(password, rows[0]['pass'], function (err, row) {
					if(row){
						req.session.loggedin = true;
						
						res.locals.rol = rows[0]['rol'].split(',');
						req.session.rol = rows[0]['rol'].split(',');

						res.render('dashboard.ejs');
					} 
					else{
						//aca iria el toats (credenciales incorrectas)
						res.render('login.ejs');
					}
				});
			}
		});
	}
});

//Fin Rutas

app.listen(2500,() => {
	console.log("El servidor corriendo en el puerto 2500");
});

