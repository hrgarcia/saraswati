const express = require('express');
const mysql = require('mysql');
const path = require('path');
const app = express();
const bodyParser = require('body-parser')

// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }));

app.use(express.static(path.join(__dirname, 'public')));

//Bootstrap requirements
app.use('/css', express.static(__dirname + '/node_modules/bootstrap/dist/css'));
app.use('/js', express.static(__dirname + '/node_modules/jquery/dist'));
app.use('/js', express.static(__dirname + '/node_modules/popper.js/dist'));
app.use('/js', express.static(__dirname + '/node_modules/bootstrap/dist/js'));

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

app.get('/agregarProfesor',(req,res) =>{
  res.render('agregarProfesor.ejs');
});

app.get('/listarProfesores',(req,res) =>{
  let query = "SELECT * FROM profesor";
  con.query(query,function(error,rows,fields){
    if(error) throw error;
    res.render('listarProfesores.ejs',{title:"Profesores",datos:rows});
  });
});

app.post('/crearProfesor', urlencodedParser, function (req, res) {
  let usuario = req.body.usuario;
	let nombre = req.body.nombre;
	let apellido = req.body.apellido;
	let dni = req.body.dni;
	let telefono = req.body.telefono;
	let email = req.body.email;
	let genero = req.body.genero;
	let nacimiento = req.body.nacimiento;
	let ingreso = req.body.ingreso;
  let estado = req.body.estado;
  
	let query = "INSERT INTO profesor (usuario,nombre,apellido,dni,telefono,email,genero,nacimiento,ingreso,estado) VALUES ('"+usuario+"','"+nombre+"','"+apellido+"','"+dni+"','"+telefono+"','"+email+"','"+genero+"','"+nacimiento+"','"+ingreso+"','"+estado+"');";
	con.query(query, function(error,rows,fields){
    if(error) throw error;
    //verificar porque datos no funciona si recargo la pagina listarProfesores luego de hacer un insert
    //res.render('listarProfesores.ejs');
		res.render('dashboard.ejs');
	})
})

//Fin Rutas

app.listen(2500,() =>{
  console.log("El servidor corriendo en el puerto 2500");
});