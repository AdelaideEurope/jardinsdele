const autoFillPrixPanier = () => {
  const array1 = [...Array(1000).keys()];
    array1.forEach(element => {
      if (document.querySelector(`#quantitejs${element}`)) {
        const getQuantite = document.querySelector(`#quantitejs${element}`);
        const getPTTTC = document.querySelector(`#prixtotaljs${element}`);
        const getPUTTC = document.querySelector(`#prixunitairejs${element}`);
        getQuantite.addEventListener('keyup', (event) => {
          const totalTTC = Math.round(((parseFloat(getPUTTC.value) * parseFloat(getQuantite.value)) + Number.EPSILON) * 100) / 100;
          getPTTTC.value = totalTTC;
        });

        getPTTTC.addEventListener('keyup', (event) => {
          const quantiteAAjouter = Math.round((parseFloat(getPTTTC.value) / parseFloat(getPUTTC.value)) * 100) / 100;
          getQuantite.value = quantiteAAjouter;
        });
      };
      if (document.querySelector(`#quantite${element}`)) {
        const getQuantite = document.querySelector(`#quantite${element}`);
        const getPTTTC = document.querySelector(`#prixtotal${element}`);
        const getPUTTC = document.querySelector(`#prixunitaire${element}`);
        getQuantite.addEventListener('keyup', (event) => {
          const totalTTC = Math.round(((parseFloat(getPUTTC.value) * parseFloat(getQuantite.value)) + Number.EPSILON) * 100) / 100;
          getPTTTC.value = totalTTC;
        });

        getPTTTC.addEventListener('keyup', (event) => {
          const quantiteAAjouter = Math.round((parseFloat(getPTTTC.value) / parseFloat(getPUTTC.value)) * 100) / 100;
          getQuantite.value = quantiteAAjouter;
        });
      };
    });

};

export { autoFillPrixPanier } ;

