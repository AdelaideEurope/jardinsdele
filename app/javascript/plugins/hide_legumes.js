const hideLegume = () => {
  const parCALegume = document.getElementById('par-ca-legume');
  const parNomLegume = document.getElementById('par-nom-legume');
  const legumesParCA = document.querySelector('.tous-legumes-ca');
  const legumesParNom = document.querySelector('.tous-legumes');


  parCALegume.addEventListener('click', (event) => {
    legumesParCA.classList.remove("hidden");
    legumesParNom.classList.add("hidden");
  })

  parNomLegume.addEventListener('click', (event) => {
    legumesParCA.classList.add("hidden");
    legumesParNom.classList.remove("hidden");
  })

};

export { hideLegume } ;

