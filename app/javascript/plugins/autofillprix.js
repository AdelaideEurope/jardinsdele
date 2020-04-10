const autoFillPrix = () => {
  const getPUHT = document.getElementById('puht');
  const getPUTTC = document.getElementById('puttc');
  const getPTHT = document.getElementById('ptht');
  const getPTTTC = document.getElementById('ptttc');
  const getQuantite = document.getElementById('quantitenew');

  getPUHT.addEventListener('change', (event) => {
    const calculTVA = parseFloat(getPUHT.value * 5.5/(100));
    const totalPUTTC = Math.round(((parseFloat(getPUHT.value) + calculTVA) + Number.EPSILON) * 100) / 100;
    const calculPUTTC = totalPUTTC
    getPUTTC.value = calculPUTTC;
    const totalHT = Math.round(((parseFloat(getPUHT.value) * parseFloat(getQuantite.value)) + Number.EPSILON) * 100) / 100;
    getPTHT.value = totalHT
    const totalTTC = parseFloat(getPUTTC.value) * parseFloat(getQuantite.value);
    getPTTTC.value = Math.round((totalTTC + Number.EPSILON) * 100) / 100
  })

  getPUTTC.addEventListener('change', (event) => {
    const calculTVA = parseFloat(getPUTTC.value * 5.5/(100));
    const totalPUHT = Math.round(((parseFloat(getPUTTC.value) - calculTVA) + Number.EPSILON) * 100) / 100;
    const calculPUHT = totalPUHT
    getPUHT.value = calculPUHT;
    const totalTTC = Math.round(((parseFloat(getPUTTC.value) * parseFloat(getQuantite.value)) + Number.EPSILON) * 100) / 100;
    getPTTTC.value = totalTTC
    const totalHT = Math.round(((parseFloat(getPUHT.value) * parseFloat(getQuantite.value)) + Number.EPSILON) * 100) / 100;
    getPTHT.value = totalHT
  })

};

export { autoFillPrix } ;

