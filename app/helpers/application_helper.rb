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
end
