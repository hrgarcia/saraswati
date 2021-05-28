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
        timer: 5000,
        timerProgressBar: true,
        toast: true,
        position: "top-end",
        showConfirmButton: false,
    });
};
