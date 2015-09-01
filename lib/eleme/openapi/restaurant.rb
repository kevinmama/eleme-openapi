#encoding: utf-8
module Eleme
  module Openapi
    module Restaurant
      class << self

        # 根据指定的ID查询餐厅信息
        def get(restaurant_id)
          Base.get("/restaurant/#{restaurant_id}/")
        end

        # 根据指定的ID查询餐厅菜单
        # 参数名	类型	是否必须	示例	描述
        # tp_id	int	否	0/1	0=不显示第三方ID，1=显示第三方ID
        def menu(restaurant_id, tp_id)
          Base.validate!(tp_id, [:tp_id, Integer, false, [1,0]])
          Base.get("/restaurant/#{restaurant_id}/menu/", tp_id: tp_id)
        end

        # 查询某一个指定餐厅的食物分类列表
        def food_categories(restaurant_id)
          Base.get("/restaurant/#{restaurant_id}/food_categories/")
        end

        BINDING_RESTAURANT_SCHEMA = [
            [:restaurant_id, Integer, true],
            [:tp_restaurant_id, String, true]
        ]
        # 绑定商户餐厅 ID，将饿了么餐厅和商户餐厅进行关联
        #
        # 参数名	类型	是否必须	示例值	描述
        # restaurant_id	int	是	123123	饿了么餐厅 ID
        # tp_restaurant_id	string	是	456789	商户餐厅 ID
        def binding(restaurant_id, tp_restaurant_id)
          params = {restaurant_id: restaurant_id, tp_restaurant_id: tp_restaurant_id.to_s}
          Base.validate!(params, BINDING_RESTAURANT_SCHEMA)
          Base.post('/restaurant/binding/', params)
        end

        # 重新绑定商户餐厅 ID
        #
        # 参数名	类型	是否必须	示例值	描述
        # restaurant_id	int	是	123123	饿了么餐厅 ID
        # tp_restaurant_id	string	是	456789	商户餐厅 ID
        def rebinding(restaurant_id, tp_restaurant_id)
          params = {restaurant_id: restaurant_id, tp_restaurant_id: tp_restaurant_id.to_s}
          Base.validate!(params, BINDING_RESTAURANT_SCHEMA)
          Base.put('/restaurant/binding/', params)
        end

        def get_by_tp_id(tp_restaurant_id)
          Base.get('/restaurant/binding/', tp_restaurant_id: tp_restaurant_id)
        end

        # 查询所属餐厅
        # 获取商户所管理的所有餐厅的ID
        def own
          Base.get('/restaurant/own/')
        end

        UPDATE_RESTAURANT_SCHEMA = [
            [:address_text, String, false],
            [:geo, String, false],
            [:agent_fee, Integer, false],
            [:close_description, String, false],
            [:description, String, false],
            [:name, String, false],
            [:is_bookable, Integer, false, [1,0]],
            [:open_time, String, false],
            [:phone, String, false],
            [:promotion_info, String, false],
            [:logo_image_hash, String, false],
            [:invoice, Integer, false],
            [:invoice_min_amount, Float, false],
            [:no_agent_fee_total, Integer, false]
        ]

        # 更新餐厅基本信息
        #
        # address_text	string	否	莘松路380号	餐厅地址
        # geo	string	否	121.371422,31.105650	longitude和latitude用英文逗号分隔
        # agent_fee	int	否	10	配送费
        # close_description	string	否	临时关闭	关店描述信息
        # deliver_description	string	否	额外4元配送费	配送额外说明
        # description	string	否	主营面食的餐厅	餐厅简介
        # name	string	否	饿了么体验店	餐厅名称
        # is_bookable	int	否	1	是否接受预定
        # open_time	string	否	10:00-13:00	餐厅营业时间，多个时间用英文逗号分隔：10:00-13:00,18:00-21:00
        # phone	string	否	15216709049	餐厅联系电话
        # promotion_info	string	否	本店新开张	餐厅公告信息
        # logo_image_hash	string	否	436552072f6da0621642453780d891a2c97b3e2f	餐厅Logo的图片image_hash（如何获得 /api/merchant/image ）
        # invoice	int	否	1	是否支持开发票(0 代表不支持，1 代表支持)
        # invoice_min_amount	float	否	30	支持的最小发票金额
        # no_agent_fee_total	int	否	15	满xx元免配送费
        def update(restaurant_id, params)
          Base.validate!(params, UPDATE_RESTAURANT_SCHEMA)
          Base.put("/restaurant/#{restaurant_id}/info/", params)
        end

        # 更新餐厅营业信息
        def update_business_status(restaurant_id, is_open)
          Base.put("/restaurant/#{restaurant_id}/business_status/", is_open: is_open)
        end

        # 更新餐厅配送范围
        #
        # geo_json的定义参考了 GEOJSON官网 ，当前只支持Polygon一种type
        # GEOJSON http://geojson.org/
        # [{"geometry": {"type": "Polygon", "coordinates": [[[121.381303, 31.243521], [121.380938, 31.242778], [121.380735, 31.242421], [121.380627, 31.242196], [121.380541, 31.24204], [121.38037, 31.241664], [121.380284, 31.241499], [121.38023, 31.241389], [121.380166, 31.241269], [121.380134, 31.241178], [121.379951, 31.24093], [121.379748, 31.24071], [121.379565, 31.240499], [121.379426, 31.24037], [121.379297, 31.240205], [121.379104, 31.239967], [121.378911, 31.239747], [121.378696, 31.239471], [121.377881, 31.238554], [121.377291, 31.237848], [121.376561, 31.237077], [121.37566, 31.236013], [121.375123, 31.235435], [121.374684, 31.234967], [121.374265, 31.234499], [121.374126, 31.23427], [121.374072, 31.234105], [121.374029, 31.233912], [121.3739, 31.233334], [121.373782, 31.232738], [121.373675, 31.232334], [121.3736, 31.231967], [121.373342, 31.230821], [121.374319, 31.23038], [121.375542, 31.22983], [121.377065, 31.229133], [121.377913, 31.228775], [121.378857, 31.228545], [121.37964, 31.228399], [121.381539, 31.228096], [121.382891, 31.227903], [121.38361, 31.229628], [121.384661, 31.231977], [121.385713, 31.23449], [121.386753, 31.236527], [121.386764, 31.236554], [121.387183, 31.237426], [121.387504, 31.238095], [121.388213, 31.239499], [121.388695, 31.24049], [121.387912, 31.240701], [121.386839, 31.240985], [121.385766, 31.241315], [121.385251, 31.241389], [121.383728, 31.24226], [121.381582, 31.243361], [121.381679, 31.243297], [121.381303, 31.243521]]]}, "type": "Feature", "properties": {"delivery_price": 20}}]
        def update_geo(restaurant_id, geo_json)
          geo_json = geo_json.to_json unless geo_json.is_a? String
          Base.put("/restaurant/#{restaurant_id}/geo/", geo_json: geo_json)
        end

        # 更新餐厅接单模式
        # 模式	含义
        # 1	使用开放平台接单
        # 2	使用napos后台接单
        # 3	使用napos的android客户端接单
        # 4	使用napos的ios客户端接单
        def update_order_mode(restaurant_id, order_mode)
          Base.validate!(order_mode, [:order_mode, Integer, true, [1,2,3,4]])
          Base.put("/restaurant/#{restaurant_id}/order_mode/", order_mode: order_mode)
        end

      end
    end
  end
end
