const minuteur = () => {
  const playButton = document.getElementById('play-button');
  const stopButton = document.getElementById('stop-button');
  const saveButton = document.getElementById('save-button');
  const newLegumes = document.getElementById('new-activite-legumes');
  const newNom = document.getElementById('new-activite-nom');
  const newTags = document.getElementById('new-activite-tags');
  const newRunning = document.getElementById('new-activite-running');
  const newFinish = document.getElementById('new-activite-finish');
  const stopButtonDiv = document.querySelector('.stop-button-div');
  const dateInput = document.getElementById('activite_date');
  const hoursSelected = document.querySelector('#activite_heure_debut_4i > option[selected]');
  const hoursSelectedEnd = document.querySelector('#activite_heure_fin_4i > option[selected]');
  const minutesSelected = document.querySelector('#activite_heure_debut_5i > option[selected]');
  const minutesSelectedEnd = document.querySelector('#activite_heure_fin_5i > option[selected]');

  playButton.addEventListener('click', (event) => {
    playButton.classList.toggle('to_hide')
    stopButtonDiv.classList.toggle('to_hide')
    newRunning.classList.toggle('hidden')
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
    newMinute.setAttribute('selected', 'selected');
    newHour.setAttribute('selected', 'selected');
    dateInput.value = newDate;
  })

  stopButton.addEventListener('click', (event) => {
    stopButtonDiv.classList.toggle('to_hide')
    saveButton.classList.toggle('to_hide')
    newNom.classList.toggle('to_hide')
    newTags.classList.toggle('to_hide')
    newLegumes.classList.toggle('to_hide')
    newFinish.classList.toggle('hidden')
    newRunning.classList.toggle('hidden')
    const dateObj = new Date()
    hoursSelectedEnd.removeAttribute('selected')
    minutesSelectedEnd.removeAttribute('selected')
    const hoursEnd = dateObj.getHours();
    const newHourEnd = getNewHourEnd(hoursEnd);
    const minutesEnd = dateObj.getMinutes();
    const newMinuteEnd = getNewMinuteEnd(minutesEnd);
    newMinuteEnd.setAttribute('selected', 'selected');
    newHourEnd.setAttribute('selected', 'selected');
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

const getNewHourEnd = (hours) => {
  if (hours < 10) {
    const newHour = document.querySelector(`#activite_heure_fin_4i > option[value='0${hours}']`)
    return newHour;
  } else {
    const newHour = document.querySelector(`#activite_heure_fin_4i > option[value='${hours}']`)
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

const getNewMinuteEnd = (minutes) => {
  if (minutes < 10) {
    const newMinute = document.querySelector(`#activite_heure_fin_5i > option[value='0${minutes}']`)
    return newMinute;
  } else {
    const newMinute = document.querySelector(`#activite_heure_fin_5i > option[value='${minutes}']`)
    return newMinute;
  }
}

export { minuteur };
