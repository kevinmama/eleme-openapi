#encoding: utf-8
module Eleme
  module Openapi
    module Food
      class << self

        # 查询食物详情
        def get(food_id, tp_id = false)
          Base::get("/food/#{food_id}/")
        end

        CREATE_FOOD_SCHEMA = [
            [:food_category_id, Integer, true],
            [:name, String, true],
            [:price, Float, true],
            [:description, String, true],
            [:max_stock, Integer, true],
            [:stock, Integer, true],
            [:tp_food_id, String, false],
            [:image_hash, String, false],
            [:is_new, Integer, false, [1,0]],
            [:is_featured, Integer, false, [1,0]],
            [:is_gum, Integer, false, [1,0]],
            [:is_spicy, Integer, false, [1,0]],
            [:packing_fee, Float, false]
        ]

        # 添加食物
        #
        # 参数名	类型	是否必须	示例	描述
        # food_category_id	int	是	123123	饿了么食物分类ID
        # name	string	是	测试	食物名称
        # price	float	是	20.0	食物单价
        # description	string	是	测试	食物描述
        # max_stock	int	是	1000	最大库存
        # stock	int	是	10	当前库存
        # tp_food_id	string	否	10213	第三方食物ID
        # image_hash	string	否	436552072f6da0621642453780d891a2c97b3e2f	图片image_hash（如何获得 /api/merchant/image）
        # is_new	int	否	1：新菜 0：非新菜	是否是新菜品
        # is_featured	int	否	1：招牌菜 0：非招牌菜	是否是招牌菜
        # is_gum	int	否	1：配菜 0：不是配菜	是否是配菜
        # is_spicy	int	否	1：辣 0：不辣	味道是否辣
        # packing_fee	float	否	0.5	菜品打包费（元）        #
        #
        def create(params)
          Base::validate!(params, CREATE_FOOD_SCHEMA)
          Base::post('/food/', params)
        end


        UPDATE_FOOD_SCHEMA = [
            [:food_category_id, Integer, false],
            [:name, String, false],
            [:price, Float, false],
            [:description, String, false],
            [:max_stock, Integer, false],
            [:stock, Integer, false],
            [:tp_food_id, String, false],
            [:image_hash, String, false],
            [:is_new, Integer, false, [1,0]],
            [:is_featured, Integer, false, [1,0]],
            [:is_gum, Integer, false, [1,0]],
            [:is_spicy, Integer, false, [1,0]],
            [:packing_fee, Float, false]
        ]

        #
        # 更新食物
        #
        # 参数名	类型	是否必须	示例	描述
        # food_category_id	int	否	123123	饿了么食物分类ID
        # name	string	否	测试	食物名称
        # price	float	否	20.0	食物单价
        # description	string	否	测试	食物描述
        # max_stock	int	否	1000	最大库存
        # stock	int	否	10	当前库存
        # tp_food_id	string	否	123123	第三方食物ID
        # image_hash	string	否	436552072f6da0621642453780d891a2c97b3e2f	图片image_hash（如何获得 /api/merchant/image ）
        # is_new	int	否	1：新菜 0：非新菜	是否是新菜品
        # is_featured	int	否	1：招牌菜 0：非招牌菜	是否是招牌菜
        # is_gum	int	否	1：配菜 0：不是配菜	是否是配菜
        # is_spicy	int	否	1：辣 0：不辣	味道是否辣
        # packing_fee	float	否	0.5	菜品打包费（元）
        def update(food_id, params)
          Base::validate!(params, UPDATE_FOOD_SCHEMA)
          Base::put("/food/#{food_id}/", params)
        end

        # 删除食物
        def delete(food_id)
          Base::delete("/food/#{food_id}/")
        end

        # 根据第三方tp_food_id查询饿了么食物ID
        def search_by_tp_ids(tp_food_ids)
          tp_food_ids = tp_food_ids.join(',') if (tp_food_ids.is_a? Array)
          Base::get('/foods/tp_food_id/', tp_food_ids: tp_food_ids)
        end

        #
        # 根据tp_food_id与tp_restaurant_id更新食物库存
        #
        # stock_info的数据结构为json
        # stock_info格式:
        #    {“tp_restaurant_id1”: {“tp_food_id1”: stock1, “tp_food_id2”: stock2}, “tp_restuarnt_id2”: {“tp_food_id1”:stock}}
        def update_stock(stock_info)
          stock_info = stock_info.to_json unless stock_info.is_a? String
          Base::put('/foods/stock/', stock_info: stock_info)
        end

      end
    end
  end
end
