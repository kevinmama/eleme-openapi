#encoding: utf-8
module Eleme
  module Openapi
    module Base
      class << self

        MAX_OPEN_TIMEOUT = 3
        MAX_READ_TIMEOUT = 10

        def get(path, params = {})
          url, url_params, body_params = prepare(path, params)
          uri = uri(url, url_params)
          http = Net::HTTP.new(uri.host, uri.port)
          http.open_timeout = MAX_OPEN_TIMEOUT
          http.read_timeout = MAX_READ_TIMEOUT
          request = Net::HTTP::Get.new(uri.request_uri)
          response = http.request(request)
          JSON.parse(response.body)
        end

        def post(path, params = {})
          body_params_request(Net::HTTP::Post, path, params)
        end

        def put(path, params = {})
          body_params_request(Net::HTTP::Put, path, params)
        end

        def delete(path, params = {})
          body_params_request(Net::HTTP::Delete, path, params)
        end

        def validate!(hash_or_object, schema)
          if (hash_or_object.is_a? Hash)
            schema.each { |item| validate_object!(hash_or_object[item[0]], item) }
          else
            validate_object!(hash_or_object, schema)
          end
        end

        private

        @@logger = Logger.new(STDOUT)

        TEST_CONSUMER_KEY = '0170804777'
        TEST_CONSUMER_SECRET = '87217cb263701f90316236c4df00d9352fb1da76'
        # @restaurant_id = '62028381'
        # @restaurant_name = '饿了么开放平台测试'

        # 公共请求参数:
        # timestamp 进行接口调用时的时间戳，即当前时间戳 （时间戳：当前距离Epoch（1970年1月1日） 以秒计算的时间，即unix-timestamp）
        # consumer_key eleme分配给APP的consumer_key
        # sig 输入参数计算后的签名结果

        def prepare(path, params, get_flag = true)
          url = "http://v2.openapi.ele.me#{path}"
          clone_params = {
              consumer_key: TEST_CONSUMER_KEY,
              consumer_secret: TEST_CONSUMER_SECRET
          }.merge(params)
          secret = clone_params.delete(:consumer_secret)
          common_params = {
              timestamp: Time.now.to_i,
              consumer_key: clone_params.delete(:consumer_key)
          }
          sign_params = common_params.merge(clone_params)
          sig = sig(url, sign_params, secret)

          if get_flag
            url_params = sign_params
            url_params[:sig] = sig
            body_params = nil
          else
            url_params = common_params
            url_params[:sig] = sig
            body_params = clone_params
          end
          @@logger.debug("[Eleme::Openapi] url_params=#{url_params}, body_params=#{body_params}")
          return url, url_params, body_params
        end

        def uri(url, params)
          uri = URI("#{url}?#{params.map{|k,v|"#{k}=#{URI.encode(v.to_s)}"}.join('&')}")
          @@logger.debug("[Eleme::Openapi] uri=#{uri}")
          uri
        end

        def sig(url, params, secret)
          # 1. 将所有参数（sig除外）按照参数名的字母顺序排序，并用 & 连接:
          a = params.map{|k,v| "#{k.to_s}=#{URI::encode(v.to_s)}"}.sort.join('&')
          # 2. 按照请求url + ? + 字符串A + consumer_secret的顺序进行连接，得到 字符串B
          b = "#{url}?#{a}#{secret}"
          # 3. 对``字符串B``用UTF-8 Encode之后计算HEX值字符串（用HEX Encode），得到``字符串C``:
          c = b.unpack('H*').first
          # 4. 对 字符串C 计算SHA1哈希，得到签名:
          Digest::SHA1.hexdigest(c)
        end

        def body_params_request(method, path, params)
          url, url_params, body_params = prepare(path, params, false)
          uri = uri(url, url_params)
          http = Net::HTTP.new(uri.host, uri.port)
          http.open_timeout = MAX_OPEN_TIMEOUT
          http.read_timeout = MAX_READ_TIMEOUT
          request = method.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})
          request.set_form_data(body_params)
          response = http.request(request)
          JSON.parse(response.body)
        end

        def present?(obj)
          obj != nil and (!obj.respond_to?(:empty?) or !obj.empty?)
        end

        def validate_object!(object, schema)
          name = schema[0]
          type = schema[1]
          require = schema[2]
          range = schema[3]

          if present?(object)
            if !object.is_a?(type)
              raise InvalidArgumentType.new(name, type, object)
            elsif present?(range)
              raise InvalidArgumentValue.new(name) unless range.include? object
            end
          elsif require
            raise MissingArgument.new(name)
          end
        end

      end
    end
  end
end
