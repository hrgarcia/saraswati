module.exports = {
    loadLearnings: loadLearnings,
};

const xlsx = require("xlsx");

function loadLearnings(excel, con) {
    const workBook = xlsx.readFile(excel);
    const sheet = workBook.SheetNames[0];
    const dataExcel = xlsx.utils.sheet_to_json(workBook.Sheets[sheet]);
    let data = {};
    let subjectName;
    let query = "SELECT id,nombreMateria FROM materia WHERE nombreMateria = ?;";

    // Save different info about learnings in a JSON for then push him in the DB
    dataExcel.map((item) => {
        subjectName = item.materia;
        if (data[subjectName] == undefined) {
            data[subjectName] = [item];
            con.query(query, [data[subjectName][0].materia], function (error, rows, fields) {
                if (error) throw error;
<<<<<<< HEAD
                if (rows.length > 0) {
                    data[rows[0].nombreMateria][0].materia = rows[0].id;
                    // si muestro esto si se modican los id
                    // console.log(data[rows[0].nombreMateria][0], "hola");
                    // console.log(data, "hola");
                } else {
                    // Notify the user that there are one or more learnings that do not exist
=======
                if(rows.length > 0){
                    data[rows[0].nombreMateria][0].id = rows[0].id
                    // si muestro esto si se modican los id
                    // console.log(data[rows[0].nombreMateria][0], "hola");
                    //console.log(data, "hola");
                }
                else{
                    // Notify the user that there are one or more subject that do not exist in the DB
>>>>>>> 58c2172e3b3c9da302d4b309dd8f3fd56b717144
                    // Toastr? Form?
                }
                // console.log(data);
            });
<<<<<<< HEAD
        } else {
=======
            
        }
        else{
>>>>>>> 58c2172e3b3c9da302d4b309dd8f3fd56b717144
            console.log("YA EXISTE ");
            data[subjectName][data[subjectName].length] = item;
            // console.log(data[subjectName][(data[subjectName].length)-1], "antes -------------");
            data[subjectName][(data[subjectName].length)-1].id = data[subjectName][0].id;
            // console.log(data[subjectName][(data[subjectName].length)-1], "despues -------------");
            //ver forma de recuperar id
        }

        /*
        let query = "INSERT INTO aprendizajes (descripcion, id_materia) VALUES (?,?);"
        con.query(query,[item.aprendizaje,"2"], function (error, rows, fields) {
            if (error) throw error;
        });
        */
    });
    //si muestro data, .materia no se modifica por los id
<<<<<<< HEAD
    //console.log(data);
}
=======
    console.log(data);
}
>>>>>>> 58c2172e3b3c9da302d4b309dd8f3fd56b717144
