const hideLegume = () => {
  const parCALegume = document.getElementById('par-ca-legume');
  const parNomLegume = document.getElementById('par-nom-legume');
  const parSemLegume = document.getElementById('par-sem-legume');
  const legumesParCA = document.querySelector('.tous-legumes-ca');
  const legumesParNom = document.querySelector('.tous-legumes');
  const legumesParSem = document.querySelector('.tous-legumes-sem');



  parCALegume.addEventListener('click', (event) => {
    legumesParCA.classList.remove("hidden");
    legumesParNom.classList.add("hidden");
    legumesParSem.classList.add("hidden");
  })

  parNomLegume.addEventListener('click', (event) => {
    legumesParCA.classList.add("hidden");
    legumesParNom.classList.remove("hidden");
    legumesParSem.classList.add("hidden");
  })

  parSemLegume.addEventListener('click', (event) => {
      legumesParCA.classList.add("hidden");
      legumesParNom.classList.add("hidden");
      legumesParSem.classList.remove("hidden");
    })

};

export { hideLegume } ;

