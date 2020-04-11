const autoFillPrixPanier = () => {
  const getPUTTC = document.getElementById('puttc-p');
  const getQuantite = document.getElementById('quantitenew-p');
  const getPTTTC = document.getElementById('ptttc-p');

  getQuantite.addEventListener('blur', (event) => {
    const calculTVA = parseFloat(getPUTTC.value * 5.5/(100));
    const totalTTC = Math.round(((parseFloat(getPUTTC.value) * parseFloat(getQuantite.value)) + Number.EPSILON) * 100) / 100;
    getPTTTC.value = totalTTC
  })

  getPUTTC.addEventListener('blur', (event) => {
  const calculTVA = parseFloat(getPUTTC.value * 5.5/(100));
  const totalTTC = Math.round(((parseFloat(getPUTTC.value) * parseFloat(getQuantite.value)) + Number.EPSILON) * 100) / 100;
  getPTTTC.value = totalTTC
})

};

export { autoFillPrixPanier } ;

