//Utilizar ES6 en lo posible
module.exports = {
	loadLearnings: loadLearnings
}

const multer  = require('multer');
const xlsx = require('xlsx');

const storage = multer.diskStorage({

	filename: function(req, file, cb){
		cb(null, file.originalname);
	}
});

var uploads = multer({
	storage : storage, 
	fileFilter: function (req, file, cb) {
	if(path.extname(file.originalname) !== '.xlsx') {
		console.log("no es un excel");
	}
	else{
		cb(null, true);
	}
	
}}).single('aprendizajes');


function loadLearnings(excel) {
	const workBook = xlsx.readFile(uploads);
	const sheet = workBook.SheetNames[0];
	const dataExcel = XLSX.utils.sheet_to_json(workBook.Sheets[sheet]);

	dataExcel.map(item => {
        let query = "INSERT INTO aprendizaje (descripcion) VALUES (item);"
		con.query(query,[description], function (error, rows, fields) {
			if (error) throw error;
		});
	});
}