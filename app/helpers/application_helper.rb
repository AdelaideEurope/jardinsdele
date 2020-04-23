module ApplicationHelper
  def ttc_to_ht(prix)
    prix - (prix * 5.5.fdiv(100))
  end

  def ht_to_ttc(prix)
    prix + (prix * 5.5.fdiv(100))
  end

  def rem_trailing_zero(num)
    if num.to_i - num == 0.to_f
      num.to_i
    else num
    end
  end

  def abreviation_jour(date)
    date = date.strftime("%u").to_i
    correspondance_datedujour_jour = { 1 => ["lundi", "lun"], 2 => ["mardi", "mar"], 3 => ["mercredi", "mer"], 4 => ["jeudi", "jeu"], 5 => ["vendredi", "ven"], 6 => ["samedi", "sam"], 7 => ["dimanche", "dim"] }
    @datedujour_jour_abrege = correspondance_datedujour_jour[date][1]
  end
end
