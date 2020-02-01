const autoFillPrix = () => {
  const getPUHT = document.getElementById('puht');
  const getPUTTC = document.getElementById('puttc');
  const getPTHT = document.getElementById('ptht');
  const getPTTTC = document.getElementById('ptttc');
  const getQuantite = document.getElementById('quantitenew');

  getPUHT.addEventListener('change', (event) => {
    const calculTVA = parseFloat(getPUHT.value * 5.5/(100));
    const totalPUTTC = parseFloat(getPUHT.value) + calculTVA;
    const calculPUTTC = totalPUTTC
    getPUTTC.value = calculPUTTC;
    const totalHT = parseFloat(getPUHT.value) * parseFloat(getQuantite.value);
    getPTHT.value = totalHT
    const totalTTC = parseFloat(getPUTTC.value) * parseFloat(getQuantite.value);
    getPTTTC.value = totalTTC
  })

  getPUTTC.addEventListener('change', (event) => {
    const calculTVA = parseFloat(getPUTTC.value * 5.5/(100));
    const totalPUHT = parseFloat(getPUTTC.value) - calculTVA;
    const calculPUHT = totalPUHT
    getPUHT.value = calculPUHT;
    const totalTTC = parseFloat(getPUTTC.value) * parseFloat(getQuantite.value);
    getPTTTC.value = totalTTC
    const totalHT = parseFloat(getPUHT.value) * parseFloat(getQuantite.value);
    getPTHT.value = totalHT
  })


};

export { autoFillPrix } ;




// const newDate = year + "-" + month + "-" + day;
//     hoursSelected.removeAttribute('selected')
//     minutesSelected.removeAttribute('selected')
//     const hours = dateObj.getHours();
//     const newHour = getNewHour(hours);
//     const minutes = dateObj.getMinutes();
//     const newMinute = getNewMinute(minutes);
//     newMinute.setAttribute('selected', 'selected');
//     newHour.setAttribute('selected', 'selected');
//     dateInput.value = newDate;
