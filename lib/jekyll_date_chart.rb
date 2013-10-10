module Jekyll
  module Tags
    class DateChartBlock < Liquid::Block
      DATE_COLUMN_NUMBER = 1
      AMOUNT_COLUMN_NUMBER = 2
      #COMMENT_COLUMN_NUMBER = 3
      
      def initialize(tag_name, draw_in_id = 'dchart', content)
        super
      end

      def render(context)
        super + render_chart(context, super)
      end
      
      def get_date_from_string(date_str)
        date_str.strip!
        # Ensure that only the specified date format is accepted
        # as Date.parse() is too lenient for the current implementation
        Date.strptime(date_str, '%d.%m.%Y')
      end
      
      def get_sum_from_value_string(value_str, sum)
        value_str = ((value_str).strip!).gsub('.','')
        value = BigDecimal(value_str.gsub('=','').gsub(',','.'))
        
        unless value_str[0] == '='
          value = sum + value
        end
        
        value
      end
      
      def update_with_changed_sums(asset, account_keys, account_sums)
        account_keys.each do |k|
          sum = BigDecimal(asset[k].to_s)
          
          if account_sums.has_key? k
            account_sums[k] = sum
          else
            account_sums.merge!(k => sum)
          end
        end
        
        account_sums
      end

      def update_with_missing_sums(asset, account_sums)
        account_sums.keys.each do |k|
          asset.merge!(k => account_sums[k]) unless asset.has_key? k
        end
        
        asset
      end
      
      def calculate_total(assets)
        total = BigDecimal('0')
        account_sums = {}

        assets.sort_by!{ |k| k[:date] }
        assets.each do |a|
          account_keys = a.keys
          account_keys.delete(:date)
          
          account_sums = update_with_changed_sums(a, account_keys, account_sums)
          a = update_with_missing_sums(a, account_sums)
          
          total = account_sums.values.inject(0) { |sum, val| sum + val }
          a.merge!(:total => total.to_f)
        end
        
        assets
      end
      
      def add_to(assets, date, ykey, sum)
        existing_date_entry_idx = assets.rindex {|entry| entry[:date] == date}
        
        if existing_date_entry_idx
          assets[existing_date_entry_idx].merge!(ykey => sum.to_f)
        else
          assets << { :date => date,
                      ykey => sum.to_f }
        end
        
        assets
      end
      
      def render_chart(context, table)
        require 'bigdecimal'
        require 'date'
        require 'json'
        
        assets = []
        ykeys = []
        units = []
        ykeys << 'total' # unless undesired
        sum = BigDecimal('0')
        
        table.lines.each do |row|
          row.strip!
   
          unless row.empty?
            row = row.split('|')

            begin
              date = get_date_from_string(row[DATE_COLUMN_NUMBER])
              raise "Unexpected: ykeys variable is empty!" if ykeys.empty?
              
              sum = get_sum_from_value_string(row[AMOUNT_COLUMN_NUMBER], sum)
              assets = add_to(assets, date, ykeys.last, sum)

            rescue ArgumentError => e
              if e.message.eql? 'invalid date'
                ykeys << (row[DATE_COLUMN_NUMBER]).strip
                units << (row[AMOUNT_COLUMN_NUMBER]).strip
              end
              
              next
            end
          end
        end
        
        assets = calculate_total(assets)
        
        raise "Duplicated table names or invalid dates encountered. ykeys: #{ykeys}" unless ykeys.uniq.length == ykeys.length
        raise "Encountered multiple units within one chart. units: #{units}" unless units.uniq.length.eql? 1
        "<div class=\"dchart\" id=\"dchart-#{rand(36**6).to_s(36)[0..5]}\" style=\"height: 450px;\" data-entries='#{assets.to_json}' data-ykeys='#{ykeys}' data-unit='#{units.uniq}'></div>"
      end
    end
  end
end

Liquid::Template.register_tag('dchart', Jekyll::Tags::DateChartBlock)
