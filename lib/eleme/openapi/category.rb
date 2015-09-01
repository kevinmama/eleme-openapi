#encoding: utf-8
module Eleme
  module Openapi
    module Category
      class << self

        # 查询食物分类详情
        def get(food_category_id)
          Base::get("/food_category/#{food_category_id}/")
        end

        # 查询分类食物列表
        def foods(food_category_id)
          Base::get("/food_category/#{food_category_id}/foods/")
        end

        CREATE_FOOD_CATEGORY_SCHEMA = [
            [:restaurant_id, Integer, true],
            [:name, String, true],
            [:weight, Integer, true]
        ]
        # 添加食物分类
        # 参数名	类型	是否必须	示例	描述
        # restaurant_id	int	是	123123	饿了么餐厅ID
        # name	string	是	测试分类	食物分类名称
        # weight	int	是	1000	食物分类权重 (数值越大越靠前)
        def create(params)
          Base::validate!(params, CREATE_FOOD_CATEGORY_SCHEMA)
          Base::post('/food_category/', params)
        end

        UPDATE_FOOD_CATEGORY_SCHEMA = [
            [:name, String, false],
            [:weight, Integer, false]
        ]

        #
        # 更新食物分类
        #
        # 请求参数
        # 参数名	类型	是否必须	示例	描述
        # name	string	否	测试分类	食物分类名称
        # weight	int	否	1000	食物分类权重 (数值越大越靠前)
        def update(food_category_id, params)
          Base::validate!(params, UPDATE_FOOD_CATEGORY_SCHEMA)
          Base::put("/food_category/#{food_category_id}/", params)
        end

        # 删除食物分类
        def delete(food_category_id)
          Base::delete("/food_category/#{food_category_id}/")
        end

      end
    end
  end
end
