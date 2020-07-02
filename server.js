const express = require('express');
const mysql = require('mysql');
const path = require('path');
const bodyParser = require('body-parser')
const session = require('express-session');
const app = express();

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
	res.render('dashboard.ejs');
});

app.get('/addTeacher',(req,res) =>{
	res.render('addTeacher.ejs');
});

app.get('/addUser',(req,res) =>{
	res.render('addUser.ejs');
});

app.get('/listarProfesores',(req,res) =>{
	let query = "SELECT * FROM profesor";
	con.query(query,function(error,rows,fields){
    if(error) throw error;
    res.render('listarProfesores.ejs',{title:"Profesores",datos:rows});
	});
});

app.post('/createTeacher', urlencodedParser, function (req, res) {
	let user = req.body.user;
	let name = req.body.name;
	let lastName = req.body.lastName;
	let dni = req.body.dni;
	let telephone = req.body.telephone;
	let email = req.body.email;
	let gender = req.body.gender;
	let birth = req.body.birth;
	let entry = req.body.entry;
	let state = req.body.state;

	let query = "INSERT INTO profesor (usuario,nombre,apellido,dni,telefono,email,genero,nacimiento,ingreso,estado) VALUES ('"+user+"','"+name+"','"+lastName+"','"+dni+"','"+telephone+"','"+email+"','"+gender+"','"+birth+"','"+entry+"','"+state+"');";
	con.query(query, function(error,rows,fields){
    if(error) throw error;
    //verificar porque datos no funciona si recargo la pagina listarProfesores luego de hacer un insert
    //res.render('listarProfesores.ejs');
	res.render('dashboard.ejs');
	});
});

app.post('/createUser', urlencodedParser, function (req, res) {
	let username = req.body.username;
	let password = req.body.password;

	let query = "INSERT INTO usuario (nombre,pass) VALUES (?,?);";
	con.query(query,[username,password], function(error,rows,fields){
    if(error) throw error;
	res.render('dashboard.ejs');
	});
});

//seguir despues de hacer la encriptacion en DB
app.post('/login', function(req, res) {
	let username = req.body.username;
	let password = req.body.password;

	if(username && password){
		let query = 'SELECT * FROM usuario WHERE nombre = ? AND pass = ?';
		con.query(query, [username, password], function(error, results, fields) {
			if(results.length > 0){
				req.session.loggedin = true;
				req.session.username = username;
				res.redirect('/dashboard');
			}
			else{
				res.send('Usuario y/o contraseña ingresadas son incorrectas');
			}			
			res.end();
		});
	} 
	else{
		res.send('Porfavor ingerese un usuario y contraseña');
		res.end();
	}
});
//Fin Rutas

app.listen(2500,() => {
	console.log("El servidor corriendo en el puerto 2500");
});