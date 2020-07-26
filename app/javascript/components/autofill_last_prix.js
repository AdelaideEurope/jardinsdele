const autoFillLastPrix = () => {
  const getPUHT = document.getElementById('puht');
  const getPUTTC = document.getElementById('puttc');
  const getPTTTC = document.getElementById('ptttc');
  const getPTHT = document.getElementById('ptht');
  const getQuantite = document.getElementById('quantitenew');
  $('#nom_legume').on("select2:select", function(e) {
    const idLegumeSelectionne = $("#nom_legume").val();
    const arrayPrix = document.querySelector('[data-legumes-prix]').dataset.legumesPrix;
    const arrPrix = JSON.parse("[" + arrayPrix + "]");
    const size = 2;
    const newArray = new Array(Math.ceil(arrPrix.length / size)).fill("").map(function() { return this.splice(0, size) }, arrPrix.slice());

    newArray.forEach((prix) => {
      if (idLegumeSelectionne === prix[0].toString()) {
        getPUHT.value = prix[1]
        const calculTVA = parseFloat(getPUHT.value * 5.5/(100));
        const totalPUTTC = Math.round(((parseFloat(getPUHT.value) + calculTVA) + Number.EPSILON) * 100) / 100;
        const calculPUTTC = totalPUTTC
        getPUTTC.value = calculPUTTC;
        const totalTTC = parseFloat(getPUTTC.value) * parseFloat(getQuantite.value);
        getPTTTC.value = Math.round((totalTTC + Number.EPSILON) * 100) / 100
        const totalHT = Math.round(((parseFloat(getPUHT.value) * parseFloat(getQuantite.value)) + Number.EPSILON) * 100) / 100;
        getPTHT.value = totalHT
      } else if (idLegumeSelectionne !== prix[0].toString()) {
        getPUHT.value = ""
        getPUTTC.value = ""
        getPTTTC.value = ""
        getPTHT.value = ""
      }
    })
  });
}

const autoFillLastPrixPanier = () => {
  const array1 = [...Array(1000).keys()];
    array1.forEach((element) => {
    if (document.querySelector(`#quantitejs${element}`)) {
      const getPUTTC = document.querySelector(`#prixunitairejs${element}`);
      const getPTTTC = document.querySelector(`#prixtotaljs${element}`);
      const getQuantite = document.querySelector(`#quantitejs${element}`);
      const legumeSelectionne = document.getElementById(`panier_ligne_legume_id${element}`)
      legumeSelectionne.addEventListener("change", () => {
        const arrayPrix = document.querySelector('[data-legumes-prix-panier]').dataset.legumesPrixPanier;
        const arrPrix = JSON.parse("[" + arrayPrix + "]");
        const size = 2;
        const newArray = new Array(Math.ceil(arrPrix.length / size)).fill("").map(function() { return this.splice(0, size) }, arrPrix.slice());
        newArray.forEach((prix) => {
          console.log(newArray)
          if (legumeSelectionne.value === prix[0].toString()) {
            getPUTTC.value = prix[1]
            const totalTTC = parseFloat(getPUTTC.value) * parseFloat(getQuantite.value);
            getPTTTC.value = totalTTC
          }
        })
      })
    }
  })
}



export {autoFillLastPrix, autoFillLastPrixPanier};


