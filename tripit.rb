require 'httparty'
require 'colorize'

class TripIt
  include HTTParty
  base_uri 'https://app.easybanking.bnpparibasfortis.be'
  debug_output

  attr_accessor :distributor_id,
                :smid,
                :agreement_id,
                :card_number,
                :obfuscated_card_number,
                :authentication_process_id,
                :challenge

  def initialize(email, password)
    self.distributor_id = '49FB001'
    self.smid = '3155596635'
    self.agreement_id = 'E0680557'
    self.card_number = '67030415034924004'
    self.obfuscated_card_number = self.card_number[0..5] + "XXXXXXX" + self.card_number[-4..-1]

    self.authentication_process_id = nil
    self.challenge = nil

    @cookie = init_cookie("deviceFeatures=|0|1|0|0|1|1|1|0|1|0|1|0|0|1|1|1080|; europolicy=optin; axes=en|TAB|fb|priv|TAB|abe454454545454df54df|; distributorid=#{self.distributor_id}; CSRF=FVs7fT6t8FlW6TeMxo2tkmA4wI2s1vTdBR47aab6xMqgEgIAs5EqKo4ESUEW5mtO7r90ven4SGiRvbxrQsd12JwDwPQPiLTgalqP4BTd24QwL1zIp9W18ag1lw2MnOBJW")
    post_response = getDistributorAuthenticationMeans
    @cookie = parse_cookie(post_response)
    post_response = getEBankingUsers
    @cookie = parse_cookie(post_response)
    post_response = createAuthenticationProcess
    @cookie = parse_cookie(post_response)
    post_response = generateChallenges
    @cookie = parse_cookie(post_response)
    post_response = hitSEEAServer
    @cookie = parse_cookie(post_response)
  end

  def logged_in?
    "test this"
  end

  private

  def getDistributorAuthenticationMeans
    puts "getDistributorAuthenticationMeans".green
    getDistributorAuthenticationMeans = self.class.post(
      '/EBIA-pr01/rpc/means/getDistributorAuthenticationMeans',
      body: {
        distributionChannelId: '49',
        distributorId: self.distributor_id,
        minimumDacLevel: '3',
        targetActivities: ''
      }.to_json,
      headers: {
        'cookie' => "deviceFeatures=|0|1|0|0|1|1|1|0|1|0|1|0|0|1|1|1080|; europolicy=optin; axes=en|TAB|fb|priv|TAB|abe454454545454df54df|; distributorid=#{self.distributor_id}; CSRF=FVs7fT6t8FlW6TeMxo2tkmA4wI2s1vTdBR47aab6xMqgEgIAs5EqKo4ESUEW5mtO7r90ven4SGiRvbxrQsd12JwDwPQPiLTgalqP4BTd24QwL1zIp9W18ag1lw2MnOBJW", 
        'user-agent' => '/APPTYPE =001/APPBRAND = fb/APPVERSION = 16.0.33/OS=android',
        'content-type' => 'application/json',
        'accept' => 'application/json',
        'host' => 'app.easybanking.bnpparibasfortis.be',
        'csrf' => 'FVs7fT6t8FlW6TeMxo2tkmA4wI2s1vTdBR47aab6xMqgEgIAs5EqKo4ESUEW5mtO7r90ven4SGiRvbxrQsd12JwDwPQPiLTgalqP4BTd24QwL1zIp9W18ag1lw2MnOBJW'
      }
    )
  end

  def getEBankingUsers
    puts "getEBankingUsers".green
    puts @cookie.to_cookie_string.inspect
    puts "deviceFeatures=|0|1|0|0|1|1|1|0|1|0|1|0|0|1|1|1080|; europolicy=optin; axes=en|TAB|fb|priv|TAB|abe454454545454df54df|; distributorid=#{self.distributor_id}; CSRF=FVs7fT6t8FlW6TeMxo2tkmA4wI2s1vTdBR47aab6xMqgEgIAs5EqKo4ESUEW5mtO7r90ven4SGiRvbxrQsd12JwDwPQPiLTgalqP4BTd24QwL1zIp9W18ag1lw2MnOBJW; ebia-pr01_JSESSIONID=0000DiRSo_dujMz-LQjcCNaZGv8:1c0j14hmj; JSESSIONID=0000jhpEwuDdkTpfUIgUILxhX5L:1ard9gfkd; gsn=25ff7a20b3705b130caf6ed5e35a63cb; w1n0_er=2384993708.47873.0000; TS013c3501=011bf91c22177d2758440d23646de15c36835067a6ce722948f0065f22e7536d9b2f3f4f06c8ad29ca5b4df9b7400f148fed78027c996b87d9c5620047ba7178b7b07236d11baa6c9d3888cd70b8678a1716d262c74e109df1a0f041f69dcf08c2044d6ec4"

    getEBankingUsers = self.class.post(
      '/EBIA-pr01/rpc/identAuth/getEBankingUsers',
      body: {
        authenticationFactorId: self.card_number,
        distributorId: self.distributor_id,
        smid: self.smid
      }.to_json,
      headers: {
        'cookie' => @cookie.to_cookie_string, 
        'user-agent' => '/APPTYPE =001/APPBRAND = fb/APPVERSION = 16.0.33/OS=android',
        'content-type' => 'application/json',
        'accept' => 'application/json',
        'host' => 'app.easybanking.bnpparibasfortis.be',
        'csrf' => 'FVs7fT6t8FlW6TeMxo2tkmA4wI2s1vTdBR47aab6xMqgEgIAs5EqKo4ESUEW5mtO7r90ven4SGiRvbxrQsd12JwDwPQPiLTgalqP4BTd24QwL1zIp9W18ag1lw2MnOBJW'
      }
    )
  end

  def createAuthenticationProcess
    puts "createAuthenticationProcess".green
    puts @cookie.to_cookie_string.inspect

    createAuthenticationProcess = self.class.post(
      '/EBIA-pr01/rpc/auth/createAuthenticationProcess',
      body: {
        authenticationMeanId: '08',
        distributorId: self.distributor_id,
        ebankingUserId: {
          agreementId: self.agreement_id,
          personId: '',
          smid: self.card_number
        },
      }.to_json,
      headers: {
        'cookie' => @cookie.to_cookie_string, 
        'user-agent' => '/APPTYPE =001/APPBRAND = fb/APPVERSION = 16.0.33/OS=android',
        'content-type' => 'application/json',
        'accept' => 'application/json',
        'host' => 'app.easybanking.bnpparibasfortis.be',
        'csrf' => 'FVs7fT6t8FlW6TeMxo2tkmA4wI2s1vTdBR47aab6xMqgEgIAs5EqKo4ESUEW5mtO7r90ven4SGiRvbxrQsd12JwDwPQPiLTgalqP4BTd24QwL1zIp9W18ag1lw2MnOBJW'
      }
    )

    self.authentication_process_id = JSON.parse(createAuthenticationProcess.body)['value']['authenticationProcessId']

    createAuthenticationProcess
  end

  def generateChallenges
    puts "generateChallenges".green
    puts @cookie.to_cookie_string.inspect

    generateChallenges = self.class.post(
      '/EBIA-pr01/rpc/auth/generateChallenges',
      body: {
        authenticationProcessId: self.authentication_process_id,
        distributorId: self.distributor_id,
      }.to_json,
      headers: {
        'cookie' => @cookie.to_cookie_string, 
        'user-agent' => '/APPTYPE =001/APPBRAND = fb/APPVERSION = 16.0.33/OS=android',
        'content-type' => 'application/json',
        'accept' => 'application/json',
        'host' => 'app.easybanking.bnpparibasfortis.be',
        'csrf' => 'FVs7fT6t8FlW6TeMxo2tkmA4wI2s1vTdBR47aab6xMqgEgIAs5EqKo4ESUEW5mtO7r90ven4SGiRvbxrQsd12JwDwPQPiLTgalqP4BTd24QwL1zIp9W18ag1lw2MnOBJW'
      }
    )

    self.challenge = JSON.parse(generateChallenges.body)['value']['challenges'][0]

    generateChallenges
  end

  def hitSEEAServer
    puts "hitSEEAServer".green
    puts @cookie.to_cookie_string.inspect

    body = %{
      AUTH=
      <DIST_ID>#{self.distributor_id}</DIST_ID>
      <AUTH_PROC_ID>#{self.authentication_process_id}</AUTH_PROC_ID>
      <MEAN_ID>FIPI</MEAN_ID>
      <EAI_AUTH_TYPE>FIPI</EAI_AUTH_TYPE>
      <EBANKING_USER_ID>
        <PERS_ID>12345678910000007</PERS_ID>
        <SMID>#{self.smid}</SMID>
        <AGRE_ID>#{self.agreement_id}</AGRE_ID>
      </EBANKING_USER_ID>
        <EBANKING_USER_AUTHENTICITY_VALIDATION>
          <VALIDATION_DATE></VALIDATION_DATE>
          <VALID></VALID>
          <AUTHENTICATION_MEAN_ID>13</AUTHENTICATION_MEAN_ID>
        </EBANKING_USER_AUTHENTICITY_VALIDATION>
        <CHALLENGE_RESPONSE>
          <VALUE>53352593</VALUE>
          <CHALLENGE>#{self.challenge}</CHALLENGE>
          <AUTH_FACTOR_ID>#{self.obfuscated_card_number}</AUTH_FACTOR_ID>
        </CHALLENGE_RESPONSE>
        <DEVICE_ID>
          <FINGER_PRINT>adc3e96d5adbf8e0c284c75224182fee1656dac7e731f216b82996d1bc001ca3</FINGER_PRINT>
          <NAME>EVA-L09</NAME>
        </DEVICE_ID>
    }

    puts body

    hitSEEAServer = self.class.post(
      '/SEEA-pa01/SEEAServer',
      body: "AUTH=%253CDIST_ID%253E#{self.distributor_id}%253C%252FDIST_ID%253E%253CAUTH_PROC_ID%253E#{self.authentication_process_id}%253C%252FAUTH_PROC_ID%253E%253CMEAN_ID%253EFIPI%253C%252FMEAN_ID%253E%253CEAI_AUTH_TYPE%253EFIPI%253C%252FEAI_AUTH_TYPE%253E%253CEBANKING_USER_ID%253E%253CPERS_ID%253E12345678910000007%253C%252FPERS_ID%253E%253CSMID%253E#{self.smid}%253C%252FSMID%253E%253CAGRE_ID%253E#{self.agreement_id}%253C%252FAGRE_ID%253E%253C%252FEBANKING_USER_ID%253E%253CEBANKING_USER_AUTHENTICITY_VALIDATION%253E%253CVALIDATION_DATE%253E%253C%252FVALIDATION_DATE%253E%253CVALID%253E%253C%252FVALID%253E%253CAUTHENTICATION_MEAN_ID%253E13%253C%252FAUTHENTICATION_MEAN_ID%253E%253C%252FEBANKING_USER_AUTHENTICITY_VALIDATION%253E%253CCHALLENGE_RESPONSE%253E%253CVALUE%253E53352593%253C%252FVALUE%253E%253CCHALLENGE%253E#{self.challenge}%253C%252FCHALLENGE%253E%253CAUTH_FACTOR_ID%253E#{self.obfuscated_card_number}%253C%252FAUTH_FACTOR_ID%253E%253C%252FCHALLENGE_RESPONSE%253E%253CDEVICE_ID%253E%253CFINGER_PRINT%253Eadc3e96d5adbf8e0c284c75224182fee1656dac7e731f216b82996d1bc001ca3%253C%252FFINGER_PRINT%253E%253CNAME%253EEVA-L09%253C%252FNAME%253E%253C%252FDEVICE_ID%253E",
      headers: {
        'cookie' => @cookie.to_cookie_string, 
        'user-agent' => '/APPTYPE =001/APPBRAND = fb/APPVERSION = 16.0.33/OS=android',
        'content-type' => 'application/json',
        'accept' => 'application/json',
        'host' => 'app.easybanking.bnpparibasfortis.be',
        'csrf' => 'FVs7fT6t8FlW6TeMxo2tkmA4wI2s1vTdBR47aab6xMqgEgIAs5EqKo4ESUEW5mtO7r90ven4SGiRvbxrQsd12JwDwPQPiLTgalqP4BTd24QwL1zIp9W18ag1lw2MnOBJW'
      }
    )
  end

  def init_cookie(cookie_string)
    @cookie_hash = CookieHash.new
    cookie_string.split('; ').each { |c| @cookie_hash.add_cookies(c) }
    @cookie_hash
  end

  def parse_cookie(resp)
    puts "parse_cookie".green
    puts resp.get_fields('Set-Cookie').inspect
    if resp.get_fields('Set-Cookie')
      resp.get_fields('Set-Cookie').each { |c| @cookie_hash.add_cookies(c) }
    end
    @cookie_hash
  end
end

tripit = TripIt.new('email', 'password')
puts "Logged in: #{tripit.logged_in?}"