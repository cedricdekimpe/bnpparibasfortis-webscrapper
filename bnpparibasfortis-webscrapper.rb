require 'colorize'
require 'open-uri'
require 'selenium-webdriver'
require 'pry'

BNPPARIBASFORTIS_LOGIN_ENDPOINT = "https://www.bnpparibasfortis.be/fr/Public/Connexion"

driver = Selenium::WebDriver.for :firefox
driver.navigate.to BNPPARIBASFORTIS_LOGIN_ENDPOINT


puts "Login to your BNP Paribas Fortis Account".red

puts "Your Card Number (6703 ---- ---- ---- -) : "

card_number = gets()

puts "Client Number (----- -----) : "

client_number = gets()

puts "waiting 10 seconds"
sleep 10

card_number_el = driver.find_element(name: 'cardNum')
card_number_el.send_keys card_number

client_number_el = driver.find_element(name: 'clientNum')
client_number_el.send_keys client_number

button_el = driver.find_element(class: 'login_btn')
button_el.click

puts "waiting 5 seconds"
sleep 5

driver.find_elements(css: 'a').detect {|el| el.text == 'Se connecter avec un lecteur de carte'}.click()

puts "waiting 5 seconds"
sleep 5

challenge_el =  driver.find_element(class: 'ucr_code__input')

challenge = challenge_el.text

puts "Insérez votre carte dans le lecteur de carte et appuyez sur " + "M1".red
puts "Introduisez " + challenge.bold + " et appuyez sur " + "OK".green
puts "Introduisez le code PIN et appuyez sur " + "OK".green
puts "Introduisez l'e-signature"

esignature = gets()

esignature_el = driver.find_element(name: 'signature')
esignature_el.send_keys esignature

button_el = driver.find_element(class: 'm1_sign_btn')
button_el.click

# binding.pry

puts "waiting 20 seconds"
sleep 20

accounts_els = driver.find_elements(css: '.list_item_detail span.no_wrap')
balances_els = driver.find_elements(css: '.list_item .list_amount span span')

puts "Vos comptes et balances".red

accounts_els.each_with_index do |account_el, i|
  puts "* #{account_el.text} : #{balances_els[i].text}"
end

other_links = ["Mes comptes", "Mes cartes", "Mes signatures"]


while true do
  sleep 60
  driver.save_screenshot("#{Time.now.to_s}.png")
  
  begin
    driver.find_elements(css: 'a').detect {|el| el.text == other_links[rand(other_links.length)]}.click()
  rescue

  end
  continue_session_text = "Rester connecté"
  continue_session_link = driver.find_elements(css: 'a').detect {|el| el.text == continue_session_text}
  
  if continue_session_link
    continue_session_link.click()
    puts "[#{Time.now.to_s}] Ah, ah, ah, ah, stayin' alive, stayin' alive".green
  else
    puts "[#{Time.now.to_s}] everything's good"
  end
end