const autoFillPrix = () => {
  const getLegume = document.getElementById('legumesaisi');
  const getPUHT = document.getElementById('puht');
  const getPUTTC = document.getElementById('puttc');
  const getPTHT = document.getElementById('ptht');
  const getPTTTC = document.getElementById('ptttc');
  const getQuantite = document.getElementById('quantitenew');

  getPUHT.addEventListener('blur', (event) => {
    const calculTVA = parseFloat(getPUHT.value * 5.5/(100));
    const totalPUTTC = parseFloat(getPUHT.value) + calculTVA;
    const calculPUTTC = totalPUTTC.toPrecision(2)
    getPUTTC.value = calculPUTTC;
    const totalHT = parseFloat(getPUHT.value) * parseFloat(getQuantite.value);
    getPTHT.value = totalHT.toPrecision(2)
    const totalTTC = parseFloat(getPUTTC.value) * parseFloat(getQuantite.value);
    getPTTTC.value = totalTTC.toPrecision(2)
  })

  getPUTTC.addEventListener('blur', (event) => {
    const calculTVA = parseFloat(getPUTTC.value * 5.5/(100));
    const totalPUHT = parseFloat(getPUTTC.value) - calculTVA;
    const calculPUHT = totalPUHT.toPrecision(2)
    getPUHT.value = calculPUHT;
    const totalTTC = parseFloat(getPUTTC.value) * parseFloat(getQuantite.value);
    getPTTTC.value = totalTTC.toPrecision(2)
    const totalHT = parseFloat(getPUHT.value) * parseFloat(getQuantite.value);
    getPTHT.value = totalHT.toPrecision(2)
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
