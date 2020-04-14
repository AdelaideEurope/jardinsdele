const autoFillPrixPanier = () => {
    const getQuantite = document.querySelectorAll('.quantitejs');
    getQuantite.forEach((item) => {
    item.addEventListener('blur', (event) => {
    const getPTTTC = document.querySelector('.prixtotaljs');
    const getPUTTC = document.querySelector('.prixunitairejs');
    const calculTVA = parseFloat(getPUTTC.value * 5.5/(100));
    const totalTTC = Math.round(((parseFloat(getPUTTC.value) * parseFloat(item.value)) + Number.EPSILON) * 100) / 100;
    getPTTTC.value = totalTTC;
    })
  });
};

export { autoFillPrixPanier } ;

