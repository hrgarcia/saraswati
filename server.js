const express = require('express');
const mysql = require('mysql');
const app = express();
const bodyParser = require('body-parser')

// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }));
var urlencodedParser = bodyParser.urlencoded({ extended: false })

var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "mydb2"
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
  res.end('Hola mundo de nuevo!');
});

//Fin Rutas

app.listen(2500,() =>{
  console.log("El servidor corriendo en el puerto 2500");
});