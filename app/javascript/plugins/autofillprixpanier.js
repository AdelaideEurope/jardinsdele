const autoFillPrixPanier = () => {
  const array1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 40];
    array1.forEach(element => {
      const getQuantite = document.querySelector(`#quantitejs${element}`);

      getQuantite.addEventListener('blur', (event) => {
        const getPTTTC = document.querySelector(`#prixtotaljs${element}`);
        const getPUTTC = document.querySelector(`#prixunitairejs${element}`);
        const calculTVA1 = parseFloat(getPUTTC.value * 5.5/(100));
        const totalTTC = Math.round(((parseFloat(getPUTTC.value) * parseFloat(getQuantite.value)) + Number.EPSILON) * 100) / 100;
        getPTTTC.value = totalTTC;
      });
    });

};

export { autoFillPrixPanier } ;

