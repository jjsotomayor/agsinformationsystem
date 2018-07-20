require "test_helper"

class TestColor < ActionDispatch::IntegrationTest


  test "Should calculate correct TSC color" do

    # Abajo y arriba
    ((10..18).step(3).to_a).each do |h|
      (400..2000).step(200) do |s|
        test_color("tsc", h, s, "amarillo")
      end
    end

    ((39..80).step(10).to_a).each do |h|
      (0..2000).step(200) do |s|
        test_color("tsc", h, s, "rojo")
      end
    end

    ((19..22).step(1).to_a).each do |h|
      (0..2000).step(200) do |s|
        color = s < 400 ? "rojo" : "amarillo"
        test_color("tsc", h, s, color)
      end
    end

    ((23..25).step(1).to_a).each do |h|
      test_color("tsc", h, 599, "rojo")
      test_color("tsc", h, 600, "amarillo")
    end

    # 700 900 1400
    h = 26
    test_color("tsc", h, 699, "rojo")
    test_color("tsc", h, 700, "amarillo")
    test_color("tsc", h, 899, "amarillo")
    test_color("tsc", h, 900, "verde")
    test_color("tsc", h, 1399, "verde")
    test_color("tsc", h, 1400, "amarillo")

    # 800 900 1400
    h = 27
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 799) != "rojo"
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 800) != "amarillo"
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 899) != "amarillo"
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 900) != "verde"
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1399) != "verde"
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1400) != "amarillo"
    test_color("tsc", h, 799, "rojo")
    test_color("tsc", h, 800, "amarillo")
    test_color("tsc", h, 899, "amarillo")
    test_color("tsc", h, 900, "verde")
    test_color("tsc", h, 1399, "verde")
    test_color("tsc", h, 1400, "amarillo")

    # 800 1000 1400
    ((28..31).step(1).to_a).each do |h|
      # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 799) != "rojo"
      # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 800) != "amarillo"
      # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 999) != "amarillo"
      # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1000) != "verde"
      # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1399) != "verde"
      # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1400) != "amarillo"
      test_color("tsc", h, 799, "rojo")
      test_color("tsc", h, 800, "amarillo")
      test_color("tsc", h, 999, "amarillo")
      test_color("tsc", h, 1000, "verde")
      test_color("tsc", h, 1399, "verde")
      test_color("tsc", h, 1400, "amarillo")
    end

    ((32..33).step(1).to_a).each do |h|
      # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 799) != "rojo"
      # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 800) != "amarillo"
      test_color("tsc", h, 799, "rojo")
      test_color("tsc", h, 800, "amarillo")
    end

    h = 34
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 999) != "rojo"
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1000) != "amarillo"
    test_color("tsc", h, 999, "rojo")
    test_color("tsc", h, 1000, "amarillo")


    # Este es intermedio
    h = 35
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1199) != "rojo"
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1200) != "amarillo"
    test_color("tsc", h, 1199, "rojo")
    test_color("tsc", h, 1200, "amarillo")

    h = 35.5
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1249) != "rojo"
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1250) != "amarillo"
    test_color("tsc", h, 1249, "rojo")
    test_color("tsc", h, 1250, "amarillo")

    # Este es intermedio
    h = 36
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1399) != "rojo" #Error
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1400) != "amarillo"
    test_color("tsc", h, 1399, "rojo")
    test_color("tsc", h, 1400, "amarillo")
    h = 36.5
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1449) != "rojo"#Error
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1450) != "amarillo"
    test_color("tsc", h, 1449, "rojo")
    test_color("tsc", h, 1450, "amarillo")
    # Este es intermedio h = 37 38 39
    h = 37
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1499) != "rojo"#Error
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1500) != "amarillo"
    test_color("tsc", h, 1499, "rojo")
    test_color("tsc", h, 1500, "amarillo")
    h = 38
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1549) != "rojo"#Error
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1550) != "amarillo"
    test_color("tsc", h, 1549, "rojo")
    test_color("tsc", h, 1550, "amarillo")
  end




  test "Should calculate correct TCC color" do
    ###############################  TCC ##################################
    # Abajo y arriba
    ((10..18).step(3).to_a).each do |h|
      (500..2000).step(200) do |s|
        test_color("tcc", h, s, "amarillo")

      end
    end

    ((38..80).step(10).to_a).each do |h|
      (0..2000).step(200) do |s|
        test_color("tcc", h, s, "rojo")
      end
    end

    ((19..23).step(1).to_a).each do |h|
      (0..2000).step(200) do |s|
        color = s < 500 ? "rojo" : "amarillo"
        test_color("tcc", h, s, color)
      end
    end

    h = 24
    test_color("tcc", h, 599, "rojo")
    test_color("tcc", h, 600, "amarillo")

    ((25..26).step(1).to_a).each do |h|
      test_color("tcc", h, 699, "rojo")
      test_color("tcc", h, 700, "amarillo")
    end

    ((27..29).step(1).to_a).each do |h|
      test_color("tcc", h, 799, "rojo")
      test_color("tcc", h, 800, "amarillo")

    end

    ((30..31).step(1).to_a).each do |h|
      test_color("tcc", h, 799, "rojo")
      test_color("tcc", h, 800, "amarillo")
      test_color("tcc", h, 899, "amarillo")
      test_color("tcc", h, 900, "verde")
      test_color("tcc", h, 1399, "verde")
      test_color("tcc", h, 1400, "amarillo")
    end

    ((32..35).step(1).to_a).each do |h|
      test_color("tcc", h, 799, "rojo")
      test_color("tcc", h, 800, "amarillo")
      test_color("tcc", h, 999, "amarillo")
      test_color("tcc", h, 1000, "verde")
      test_color("tcc", h, 1399, "verde")
      test_color("tcc", h, 1400, "amarillo")
    end

    ((36..37).step(1).to_a).each do |h|
      test_color("tcc", h, 799, "rojo")
      test_color("tcc", h, 800, "amarillo")
    end

  end

  test "Should calculate rojo color for TSC and TCC when only HUMIDITY given" do
    test_color("tsc", 39, nil, "rojo")
    test_color("tsc", 60, nil, "rojo")
    test_color("tcc", 38, nil, "rojo")
    test_color("tcc", 60, nil, "rojo")
  end

  test "Should calculate rojo color for TSC and TCC when only SORBATE given" do
    test_color("tsc", nil, 100, "rojo")
    test_color("tsc", nil, 399, "rojo")
    test_color("tcc", nil, 100, "rojo")
    test_color("tcc", nil, 499, "rojo")
  end

  test "Should return nil when unable to determine color" do
    test_color("tsc", 38.9, nil, nil)
    test_color("tcc", 37.9, nil, nil)
    test_color("tsc", nil, 400, nil)
    test_color("tcc", nil, 500, nil)
  end

  test "Should calculate correct SEAM color" do
    test_color("seam", 17.9, nil, "amarillo")
    test_color("seam", 18, nil, "verde")
    test_color("seam", 21.9, nil, "verde")
    test_color("seam", 22, nil, "rojo")
  end

  test "Should calculate correct CN, CALIBRADO, SECADO color" do
    ["cn", "calibrado", "secado"].each do |pt_name|
      test_color(pt_name, 15.9, nil, "amarillo")
      test_color(pt_name, 16, nil, "verde")
      test_color(pt_name, 19.9, nil, "verde")
      test_color(pt_name, 20, nil, "rojo")
    end
  end



end
