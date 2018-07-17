require "test_helper"

class TestColor < ActionDispatch::IntegrationTest


  test "Should calculate correct TSC color" do

    # Abajo y arriba
    ((10..18).step(3).to_a).each do |h|
      (400..2000).step(200) do |s|
        test_color("tsc", h, s, "yellow")
      end
    end

    ((39..80).step(10).to_a).each do |h|
      (0..2000).step(200) do |s|
        test_color("tsc", h, s, "red")
      end
    end

    ((19..22).step(1).to_a).each do |h|
      (0..2000).step(200) do |s|
        color = s < 400 ? "red" : "yellow"
        test_color("tsc", h, s, color)
      end
    end

    ((23..25).step(1).to_a).each do |h|
      test_color("tsc", h, 599, "red")
      test_color("tsc", h, 600, "yellow")
    end

    # 700 900 1400
    h = 26
    test_color("tsc", h, 699, "red")
    test_color("tsc", h, 700, "yellow")
    test_color("tsc", h, 899, "yellow")
    test_color("tsc", h, 900, "green")
    test_color("tsc", h, 1399, "green")
    test_color("tsc", h, 1400, "yellow")

    # 800 900 1400
    h = 27
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 799) != "red"
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 800) != "yellow"
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 899) != "yellow"
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 900) != "green"
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1399) != "green"
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1400) != "yellow"
    test_color("tsc", h, 799, "red")
    test_color("tsc", h, 800, "yellow")
    test_color("tsc", h, 899, "yellow")
    test_color("tsc", h, 900, "green")
    test_color("tsc", h, 1399, "green")
    test_color("tsc", h, 1400, "yellow")

    # 800 1000 1400
    ((28..31).step(1).to_a).each do |h|
      # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 799) != "red"
      # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 800) != "yellow"
      # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 999) != "yellow"
      # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1000) != "green"
      # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1399) != "green"
      # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1400) != "yellow"
      test_color("tsc", h, 799, "red")
      test_color("tsc", h, 800, "yellow")
      test_color("tsc", h, 999, "yellow")
      test_color("tsc", h, 1000, "green")
      test_color("tsc", h, 1399, "green")
      test_color("tsc", h, 1400, "yellow")
    end

    ((32..33).step(1).to_a).each do |h|
      # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 799) != "red"
      # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 800) != "yellow"
      test_color("tsc", h, 799, "red")
      test_color("tsc", h, 800, "yellow")
    end

    h = 34
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 999) != "red"
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1000) != "yellow"
    test_color("tsc", h, 999, "red")
    test_color("tsc", h, 1000, "yellow")


    # Este es intermedio
    h = 35
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1199) != "red"
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1200) != "yellow"
    test_color("tsc", h, 1199, "red")
    test_color("tsc", h, 1200, "yellow")

    h = 35.5
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1249) != "red"
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1250) != "yellow"
    test_color("tsc", h, 1249, "red")
    test_color("tsc", h, 1250, "yellow")

    # Este es intermedio
    h = 36
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1399) != "red" #Error
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1400) != "yellow"
    test_color("tsc", h, 1399, "red")
    test_color("tsc", h, 1400, "yellow")
    h = 36.5
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1449) != "red"#Error
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1450) != "yellow"
    test_color("tsc", h, 1449, "red")
    test_color("tsc", h, 1450, "yellow")
    # Este es intermedio h = 37 38 39
    h = 37
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1499) != "red"#Error
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1500) != "yellow"
    test_color("tsc", h, 1499, "red")
    test_color("tsc", h, 1500, "yellow")
    h = 38
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1549) != "red"#Error
    # puts "ERROR #{h}," if Color.calculate_color("tsc", h, 1550) != "yellow"
    test_color("tsc", h, 1549, "red")
    test_color("tsc", h, 1550, "yellow")
  end




  test "Should calculate correct TCC color" do
    ###############################  TCC ##################################
    # Abajo y arriba
    ((10..18).step(3).to_a).each do |h|
      (500..2000).step(200) do |s|
        test_color("tcc", h, s, "yellow")

      end
    end

    ((38..80).step(10).to_a).each do |h|
      (0..2000).step(200) do |s|
        test_color("tcc", h, s, "red")
      end
    end

    ((19..23).step(1).to_a).each do |h|
      (0..2000).step(200) do |s|
        color = s < 500 ? "red" : "yellow"
        test_color("tcc", h, s, color)
      end
    end

    h = 24
    test_color("tcc", h, 599, "red")
    test_color("tcc", h, 600, "yellow")

    ((25..26).step(1).to_a).each do |h|
      test_color("tcc", h, 699, "red")
      test_color("tcc", h, 700, "yellow")
    end

    ((27..29).step(1).to_a).each do |h|
      test_color("tcc", h, 799, "red")
      test_color("tcc", h, 800, "yellow")

    end

    ((30..31).step(1).to_a).each do |h|
      test_color("tcc", h, 799, "red")
      test_color("tcc", h, 800, "yellow")
      test_color("tcc", h, 899, "yellow")
      test_color("tcc", h, 900, "green")
      test_color("tcc", h, 1399, "green")
      test_color("tcc", h, 1400, "yellow")
    end

    ((32..35).step(1).to_a).each do |h|
      test_color("tcc", h, 799, "red")
      test_color("tcc", h, 800, "yellow")
      test_color("tcc", h, 999, "yellow")
      test_color("tcc", h, 1000, "green")
      test_color("tcc", h, 1399, "green")
      test_color("tcc", h, 1400, "yellow")
    end

    ((36..37).step(1).to_a).each do |h|
      test_color("tcc", h, 799, "red")
      test_color("tcc", h, 800, "yellow")
    end

  end

  test "Should calculate red color for TSC and TCC when only HUMIDITY given" do
    test_color("tsc", 39, nil, "red")
    test_color("tsc", 60, nil, "red")
    test_color("tcc", 38, nil, "red")
    test_color("tcc", 60, nil, "red")
  end

  test "Should calculate red color for TSC and TCC when only SORBATE given" do
    test_color("tsc", nil, 100, "red")
    test_color("tsc", nil, 399, "red")
    test_color("tcc", nil, 100, "red")
    test_color("tcc", nil, 499, "red")
  end

  test "Should return nil when unable to determine color" do
    test_color("tsc", 38.9, nil, nil)
    test_color("tcc", 37.9, nil, nil)
    test_color("tsc", nil, 400, nil)
    test_color("tcc", nil, 500, nil)
  end

  test "Should calculate correct SEAM color" do
    test_color("seam", 17.9, nil, "yellow")
    test_color("seam", 18, nil, "green")
    test_color("seam", 21.9, nil, "green")
    test_color("seam", 22, nil, "red")
  end

  test "Should calculate correct CN, CALIBRADO, SECADO color" do
    ["cn", "calibrado", "secado"].each do |pt_name|
      test_color(pt_name, 15.9, nil, "yellow")
      test_color(pt_name, 16, nil, "green")
      test_color(pt_name, 19.9, nil, "green")
      test_color(pt_name, 20, nil, "red")
    end
  end



end
