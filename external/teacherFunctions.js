module.exports = {
    loadLearnings: loadLearnings,
};

const xlsx = require("xlsx");
const fs = require("fs");

function deleteDiacritics(text) {
    return text.normalize("NFD").replace(/[\u0300-\u036f]/g, "");
}

function loadLearnings(file, con, typeOFile, trimester, idSubject) {
    if (typeOFile == "excel") {
        const workBook = xlsx.readFile(file);
        const sheet = workBook.SheetNames[0];
        const dataExcel = xlsx.utils.sheet_to_json(workBook.Sheets[sheet]);

        let nameLearnings = [];
        let data;

        dataExcel.map((item) => {
            if (item.aprendizajes != undefined) {
                data = item.aprendizajes.toLowerCase();
                data = deleteDiacritics(data);
                nameLearnings.push(data);
            }
        });
        insertLearningsDB(con, nameLearnings, trimester, idSubject);
    }
    if (typeOFile == "txt") {
        const readLineBySeparateLines = (filename) => {
            let data = fs.readFileSync(filename);
            data = data.toString().toLowerCase();
            data = deleteDiacritics(data);
            return data;
        };
        let nameLearnings = readLineBySeparateLines(file);
        nameLearnings = nameLearnings.split("\r\n");
        for (let i = 0; i < nameLearnings.length; i++) {
            if (nameLearnings == " ") {
                nameLearnings[i].splice(i, 1);
            }
        }
        insertLearningsDB(con, nameLearnings, trimester, idSubject);
    }
}

function insertLearningsDB(con, nameLearnings, trimester, idSubject) {
    // Search for the DNI of all students in this subject
    let query1 = "SELECT dni FROM estudiante INNER JOIN materia WHERE materia.id = ? AND estudiante.descripcion_curso = materia.curso_descripcion";

    // Create the learning base
    // Search for the DNI of all students in this subject
    let query2 = "INSERT INTO aprendizajes (descripcion,id_materia,id_periodo) VALUES (?, ?, ?)";
    let query3 = "INSERT INTO estudianteaprendizaje (descripcion,estado,estudiante_dni,periodo_id,materia_id) VALUES (?,?,?,?,?)";

    con.query(query1, [idSubject], (error, rows, fields) => {
        if (error) throw error;
        for (let i = 0; i < nameLearnings.length; i++) {
            con.query(query2, [nameLearnings[i], idSubject, trimester], (error, row, fields) => {
                if (error) throw error;
            });
            // With a for I create each learning for each student
            for (let x = 0; x < rows.length; x++) {
                con.query(query3, [nameLearnings[i], "pendiente", rows[x].dni, trimester, idSubject], (error, row2, fields) => {
                    if (error) throw error;
                });
            }
        }
    });
    // SweetAlert all it's fine
}
