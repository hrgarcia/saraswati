module.exports = {
    connection: connection
}

const mysql = require("mysql");


function connection(){
    var con = mysql.createConnection({
        host: "localhost",
        user: "root",
        password: "",
        database: "saraswatidb"
    });

    con.connect(function (error) {
        if (error) throw error;
        console.log("Conectado a la DB");
    });
    return con;
}