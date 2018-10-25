require 'uri'
require 'net/https'
require 'awesome_print'
require 'json'

module BNPParibasFortis
  class Login
    def initialize
      @cookie = nil
      # getDistributorAuthenticationMeans
      getEBankingUsers
      # intermetiateRequest01
      # intermetiateRequest02
      createAuthenticationProcess
    end

    private

    # def getDistributorAuthenticationMeans

    #   url = URI("https://app.easybanking.bnpparibasfortis.be/EBIA-pr01/rpc/means/getDistributorAuthenticationMeans")

    #   http = Net::HTTP.new(url.host, url.port)
    #   http.use_ssl = true
    #   http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    #   request = Net::HTTP::Post.new(url)
    #   request["cookie"] = 'deviceFeatures=|0|1|0|0|1|1|1|0|1|0|1|0|0|1|1|1080|; europolicy=optin; axes=en|TAB|fb|priv|TAB|abe454454545454df54df|; distributorid=49FB001; CSRF=FVs7fT6t8FlW6TeMxo2tkmA4wI2s1vTdBR47aab6xMqgEgIAs5EqKo4ESUEW5mtO7r90ven4SGiRvbxrQsd12JwDwPQPiLTgalqP4BTd24QwL1zIp9W18ag1lw2MnOBJW'
    #   request["content-type"] = 'application/json'
    #   request["accept"] = 'application/json'
    #   request["csrf"] = 'FVs7fT6t8FlW6TeMxo2tkmA4wI2s1vTdBR47aab6xMqgEgIAs5EqKo4ESUEW5mtO7r90ven4SGiRvbxrQsd12JwDwPQPiLTgalqP4BTd24QwL1zIp9W18ag1lw2MnOBJW'
    #   request["user-agent"] = '/APPTYPE =001/APPBRAND = fb/APPVERSION = 16.0.33/OS=android'
    #   request["host"] = 'app.easybanking.bnpparibasfortis.be'
    #   request.body = "{\"distributionChannelId\":\"49\",\"distributorId\":\"49FB001\",\"minimumDacLevel\":\"3\",\"targetActivities\":\"\"}"

    #   response = http.request(request)
    #   ap JSON.parse(response.read_body)
    # end

    def getEBankingUsers
      url = URI("https://app.easybanking.bnpparibasfortis.be/EBIA-pr01/rpc/identAuth/getEBankingUsers")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(url)
      request["cookie"] = 'deviceFeatures=|0|1|0|0|1|1|1|0|1|0|1|0|0|1|1|1080|; europolicy=optin; axes=en|TAB|fb|priv|TAB|abe454454545454df54df|; distributorid=49FB001; CSRF=FVs7fT6t8FlW6TeMxo2tkmA4wI2s1vTdBR47aab6xMqgEgIAs5EqKo4ESUEW5mtO7r90ven4SGiRvbxrQsd12JwDwPQPiLTgalqP4BTd24QwL1zIp9W18ag1lw2MnOBJW; ebia-pr01_JSESSIONID=0000DiRSo_dujMz-LQjcCNaZGv8:1c0j14hmj; JSESSIONID=0000jhpEwuDdkTpfUIgUILxhX5L:1ard9gfkd; gsn=25ff7a20b3705b130caf6ed5e35a63cb; w1n0_er=2384993708.47873.0000; TS013c3501=011bf91c22177d2758440d23646de15c36835067a6ce722948f0065f22e7536d9b2f3f4f06c8ad29ca5b4df9b7400f148fed78027c996b87d9c5620047ba7178b7b07236d11baa6c9d3888cd70b8678a1716d262c74e109df1a0f041f69dcf08c2044d6ec4'
      request["content-type"] = 'application/json'
      request["accept"] = 'application/json'
      request["csrf"] = 'FVs7fT6t8FlW6TeMxo2tkmA4wI2s1vTdBR47aab6xMqgEgIAs5EqKo4ESUEW5mtO7r90ven4SGiRvbxrQsd12JwDwPQPiLTgalqP4BTd24QwL1zIp9W18ag1lw2MnOBJW'
      request["user-agent"] = '/APPTYPE =001/APPBRAND = fb/APPVERSION = 16.0.33/OS=android'
      request["host"] = 'app.easybanking.bnpparibasfortis.be'
      request.body = "{\"authenticationFactorId\":\"67030415034924004\",\"distributorId\":\"49FB001\",\"smid\":\"3155596635\"}"


      response = http.request(request)
      ap response.response['set-cookie']
      @cookie = response.response['set-cookie']
      ap JSON.parse(response.read_body)
    end

    # def intermetiateRequest01
    #   url = URI("https://bnpparibasfortis.sc.omtrdc.net/b/ss/bnp.be.fb.allapps.app.prod%2Cbnp.be.all.global.all.prod/0/JAVA-4.8.1-AN/s12916002")

    #   http = Net::HTTP.new(url.host, url.port)
    #   http.use_ssl = true
    #   http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    #   request = Net::HTTP::Post.new(url)
    #   request["user-agent"] = 'Mozilla/5.0 (Linux; U; Android 7.0; en; EVA-L09 Build/HUAWEIEVA-L09)'
    #   request["accept-language"] = 'en'
    #   request["host"] = 'bnpparibasfortis.sc.omtrdc.net'
    #   request.body = "ndh=1&ce=UTF-8&c.&a.&DeviceName=EVA-L09&OSVersion=Android%207.0&TimeSinceLaunch=57&RunMode=Application&Resolution=1080x1794&CarrierName=Proximus&AppID=Easy%20Banking%2016.0.33%20%28160033%29&.a&digitalData.&user.&segment.&.segment&attributes.&status=loggedoff&authenticationStatus=0&.attributes&profileInfo.&.profileInfo&.user&page.&attributes.&sysEnv=49&subCategory1=priv&primaryCategory=fb&language=en&subCategory2=daily%20banking&.attributes&pageInfo.&pageID=start%20screen&pageNameContext=fb%3Apriv%3Adaily%20banking%3Astart%20screen&url=https%3A%2F%2Fapp.easybanking.bnpparibasfortis.be&.pageInfo&.page&DataLayerMetadata.&pageReady=Y&dataLayerVersion=V3.0&.DataLayerMetadata&.digitalData&.c&t=00%2F00%2F0000%2000%3A00%3A00%200%20-120&pageName=fb%3Apriv%3Adaily%20banking%3Astart%20screen&aid=1405259996834AA6-0C79736BABA493E9"

    #   response = http.request(request)
    #   puts response.read_body
    # end

    # def intermetiateRequest02
    #   url = URI("https://bnpparibasfortis.sc.omtrdc.net/b/ss/bnp.be.fb.allapps.app.prod%2Cbnp.be.all.global.all.prod/0/JAVA-4.8.1-AN/s62950081")

    #   http = Net::HTTP.new(url.host, url.port)
    #   http.use_ssl = true
    #   http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    #   request = Net::HTTP::Post.new(url)
    #   request["user-agent"] = 'Mozilla/5.0 (Linux; U; Android 7.0; en; EVA-L09 Build/HUAWEIEVA-L09)'
    #   request["accept-language"] = 'en'
    #   request["host"] = 'bnpparibasfortis.sc.omtrdc.net'
    #   request.body = "ndh=1&ce=UTF-8&c.&a.&DeviceName=EVA-L09&OSVersion=Android%207.0&TimeSinceLaunch=67&RunMode=Application&Resolution=1080x1794&CarrierName=Proximus&AppID=Easy%20Banking%2016.0.33%20%28160033%29&.a&digitalData.&user.&segment.&.segment&attributes.&status=loggedoff&authenticationStatus=0&.attributes&profileInfo.&.profileInfo&.user&page.&attributes.&sysEnv=49&subCategory1=priv&level4=login&primaryCategory=fb&language=en&subCategory2=general&.attributes&pageInfo.&pageID=login%3Acard%20information&pageNameContext=fb%3Apriv%3Ageneral%3Alogin%3Acard%20information&url=https%3A%2F%2Fapp.easybanking.bnpparibasfortis.be&.pageInfo&.page&DataLayerMetadata.&pageReady=Y&dataLayerVersion=V3.0&.DataLayerMetadata&.digitalData&.c&t=00%2F00%2F0000%2000%3A00%3A00%200%20-120&pageName=fb%3Apriv%3Ageneral%3Alogin%3Acard%20information&aid=1405259996834AA6-0C79736BABA493E9"

    #   response = http.request(request)
    #   puts response.read_body
    # end

    def createAuthenticationProcess
      url = URI("https://app.easybanking.bnpparibasfortis.be/EBIA-pr01/rpc/auth/createAuthenticationProcess")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(url)
      request["cookie"] = @cookie
      request["content-type"] = 'application/json'
      request["accept"] = 'application/json'
      request["csrf"] = 'FVs7fT6t8FlW6TeMxo2tkmA4wI2s1vTdBR47aab6xMqgEgIAs5EqKo4ESUEW5mtO7r90ven4SGiRvbxrQsd12JwDwPQPiLTgalqP4BTd24QwL1zIp9W18ag1lw2MnOBJW'
      request["user-agent"] = '/APPTYPE =001/APPBRAND = fb/APPVERSION = 16.0.33/OS=android'
      request["host"] = 'app.easybanking.bnpparibasfortis.be'
      request.body = "{\"authenticationMeanId\":\"08\",\"distributorId\":\"49FB001\",\"ebankingUserId\":{\"agreementId\":\"E0680557\",\"personId\":\"\",\"smid\":\"67030415034924004\"}}"

      response = http.request(request)
      ap response.response['set-cookie']
      @cookie = response.response['set-cookie']
      ap JSON.parse(response.read_body)
    end
  end

end

BNPParibasFortis::Login.new()