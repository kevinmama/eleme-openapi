#encoding: utf-8
module Eleme
  module Openapi
    module Order
      class << self

        # 查询新订单
        def new(restaurant_id = nil)
          Base::get('/order/new/', restaurant_id: restaurant_id)
        end

        # 查询订单详情
        def get(eleme_order_id)
          Base::get("/order/#{eleme_order_id}/", {tp_id: 1})
        end

        # 查询订单状态
        def status(eleme_order_id)
          Base::get("/order/#{eleme_order_id}/status/")
        end

        # 取消订单
        def cancel(eleme_order_id, reason)
          Base::put("/order/#{eleme_order_id}/status/", status: -1, reason: reason)
        end

        # 确认订单
        def confirm(eleme_order_id)
          Base::put("/order/#{eleme_order_id}/status/", status: 2)
        end

      end
    end
  end
end
