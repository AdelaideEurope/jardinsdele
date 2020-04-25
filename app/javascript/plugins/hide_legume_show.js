const hideLegumeShow = () => {
  const selectGraphLegume = document.getElementById('graph-legume');
  const selectTableLegume = document.getElementById('tableau-legume');
  const graphLegume = document.getElementById('chart-legume');
  const tableLegume = document.getElementById('table-show-legume');


  selectGraphLegume.addEventListener('click', (event) => {
    graphLegume.classList.remove("hidden");
    tableLegume.classList.add("hidden");
  })

  selectTableLegume.addEventListener('click', (event) => {
    graphLegume.classList.add("hidden");
    tableLegume.classList.remove("hidden");
  })

};

export { hideLegumeShow } ;

