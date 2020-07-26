const derniereFoisLegumePanier = () => {
  const array1 = [...Array(1000).keys()];
    array1.forEach((element) => {
    if (document.querySelector(`#quantitejs${element}`)) {
      const legumeSelectionne = document.getElementById(`panier_ligne_legume_id${element}`)
      const getQuantite = document.querySelector(`#quantitejs${element}`);
      legumeSelectionne.addEventListener("change", () => {
        const arrayPrix = document.querySelector('[data-legumes-dernier-panier]').dataset.legumesDernierPanier;
        const arrPrix = arrayPrix.split(",").slice(0, -1)
        const size = 2;
        const newArray = new Array(Math.ceil(arrPrix.length / size)).fill("").map(function() { return this.splice(0, size) }, arrPrix.slice());
        console.log(newArray)
        newArray.forEach((date) => {
          if (legumeSelectionne.value === date[0].toString()) {
            // document.querySelector(`.derniere-fois-panier${element}`).classList.toggle("hidden");
            // console.log("deja mis dans un panier")
            // console.log(date[1])
            console.log(date[1] === "0")
            document.querySelector(`.derniere-fois-panier${element}`).innerHTML = `<div>Dernière fois que ce légume a été dans un panier : ${date[1].substring(0,2)}/${date[1].substring(2,4)}</div>`
          }
          // else if (legumeSelectionne.value !== date[0].toString()) {
          //   console.log("jamais mis dans un panier")
          //   console.log(date[1])
          //   document.querySelector(`.derniere-fois-panier${element}`).classList.add("hidden");
          // }
        })
      })
    }
  })
}

export { derniereFoisLegumePanier };
