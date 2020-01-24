const minuteur = () => {
  const playButton = document.getElementById('play-button');
  const dateInput = document.getElementById('activite_date');
  const hoursSelected = document.querySelector('#activite_heure_debut_4i > option[selected]');
  const minutesSelected = document.querySelector('#activite_heure_debut_5i > option[selected]');

  playButton.addEventListener('click', (event) => {
    playButton.classList.toggle('to_hide')
    const dateObj = new Date()
    const month = dateObj.getUTCMonth() + 1; //months from 1-12
    const day = dateObj.getUTCDate();
    const year = dateObj.getUTCFullYear();
    const newDate = year + "-" + month + "-" + day;
    hoursSelected.removeAttribute('selected')
    minutesSelected.removeAttribute('selected')
    const hours = dateObj.getHours();
    const newHour = getNewHour(hours);
    const minutes = dateObj.getMinutes();
    const newMinute = getNewMinute(minutes);
    newMinute.setAttribute('selected', 'selected')
    newHour.setAttribute('selected', 'selected')
    dateInput.value = newDate;
  })
}

const getNewHour = (hours) => {
  if (hours < 10) {
    const newHour = document.querySelector(`#activite_heure_debut_4i > option[value='0${hours}']`)
    return newHour;
  } else {
    const newHour = document.querySelector(`#activite_heure_debut_4i > option[value='${hours}']`)
    return newHour;
  }
}

const getNewMinute = (minutes) => {
  if (minutes < 10) {
    const newMinute = document.querySelector(`#activite_heure_debut_5i > option[value='0${minutes}']`)
    return newMinute;
  } else {
    const newMinute = document.querySelector(`#activite_heure_debut_5i > option[value='${minutes}']`)
    return newMinute;
  }
}

export { minuteur };
