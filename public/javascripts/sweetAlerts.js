const welcomeLogin = (text) => {
    Swal.fire({
        icon: "success",
        title: `Bienvenido ${text}`,
        timer: 5000,
        timerProgressBar: true,
        toast: true,
        position: "top-end",
        showConfirmButton: false,
    });
};

const errorAlert = (text) => {
    Swal.fire({
        icon: "error",
        title: `${text}`,
        timer: 3000,
        showConfirmButton: false,
        timerProgressBar: true,
        toast: true,
        position: "top-end",
    });
};

const successAlert = (text) => {
    Swal.fire({
        icon: "success",
        title: `${text}`,
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true,
        toast: true,
        position: "top-end",
    });
};

const saveAlert = (texto) => {
    Swal.fire({
        icon: "question",
        title: `${texto}`,
        showCancelButton: true,
        confirmButtonText: `Guardar`,
    }).then((result) => {
        if (result.isConfirmed) {
            saveLearnings();
        }
    });
};
