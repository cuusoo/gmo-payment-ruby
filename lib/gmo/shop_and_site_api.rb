# coding: utf-8
module GMO
  module Payment

    module ShopAndSiteAPIMethods
      def initialize(options = {})
        @shop_id   = options[:shop_id]
        @shop_pass = options[:shop_pass]
        @site_id   = options[:site_id]
        @site_pass = options[:site_pass]
        @host      = options[:host]
        unless @site_id && @site_pass && @shop_id && @shop_pass && @host
          raise ArgumentError, "Initialize must receive a hash with :site_id, :site_pass, :shop_id, :shop_pass and either :host! (received #{options.inspect})"
        end
      end
      attr_reader :shop_id, :shop_pass, :site_id, :site_pass, :host

      # 2.17.2.1.決済後カード登録
      # 指定されたオーダーID の取引に使用したカードを登録します。
      ### @return ###
      # CardSeq
      # CardNo
      # Forward
      def trade_card(options = {})
        name = "TradedCard.idPass"
        required = [:order_id, :member_id]
        assert_required_options(required, options)
        post_request name, options
      end

      private

        def api_call(name, args = {}, verb = "post", options = {})
          args.merge!({
            "ShopID"   => @shop_id,
            "ShopPass" => @shop_pass,
            "SiteID"   => @site_id,
            "SitePass" => @site_pass
          })
          response = api(name, args, verb, options) do |response|
            if response.is_a?(Hash) && !response["ErrInfo"].nil?
              raise APIError.new(response)
            end
          end
          response
        end

    end
  end
end