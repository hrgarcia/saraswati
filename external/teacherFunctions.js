module.exports = {
    loadLearnings: loadLearnings
}

const xlsx = require('xlsx');

function loadLearnings(excel, con) {
    const workBook = xlsx.readFile(excel);
    const sheet = workBook.SheetNames[0];
    const dataExcel = xlsx.utils.sheet_to_json(workBook.Sheets[sheet]);

    dataExcel.map(item => {
        console.log(item);
        /*
        let subjectId=[];
        console.log(item.materia);
        let query = "SELECT id FROM materia WHERE nombreMateria = ?;"
        con.query(query,[item.materia], function (error, rows, fields) {
            if (error) throw error;
            subjectId.push(rows);
        });
        
        let query = "INSERT INTO aprendizajes (descripcion, id_materia) VALUES (?,?);"
        con.query(query,[item.aprendizaje,"2"], function (error, rows, fields) {
            if (error) throw error;
        });
        */
    });
}