require 'nokogiri'
require 'open-uri'

module ProfileParser
  LOCATION_HASH = {
    'Alabama' => 'AL',
  	'Alaska' => 'AK',
  	'Arizona' => 'AZ',
  	'Arkansas' => 'AR',
  	'California' => 'CA',
  	'Colorado' => 'CO',
  	'Connecticut' => 'CT',
  	'Delaware' => 'DE',
  	'District of Columbia' => 'DC',
  	'Florida' => 'FL',
  	'Georgia' => 'GA',
  	'Hawaii' => 'HI',
  	'Idaho' => 'ID',
  	'Illinois' => 'IL',
  	'Indiana' => 'IN',
  	'Iowa' => 'IA',
  	'Kansas' => 'KS',
  	'Kentucky' => 'KY',
  	'Louisiana' => 'LA',
  	'Maine' => 'ME',
  	'Maryland' => 'MD',
  	'Massachusetts' => 'MA',
  	'Michigan' => 'MI',
  	'Minnesota' => 'MN',
  	'Mississippi' => 'MS',
  	'Missouri' => 'MO',
  	'Montana' => 'MT',
  	'Nebraska' => 'NE',
  	'Nevada' => 'NV',
  	'New Hampshire' => 'NH',
  	'New Jersey' => 'NJ',
  	'New Mexico' => 'NM',
  	'New York' => 'NY',
  	'North Carolina' => 'NC',
  	'North Dakota' => 'ND',
  	'Ohio' => 'OH',
  	'Oklahoma' => 'OK',
  	'Oregon' => 'OR',
  	'Pennsylvania' => 'PA',
  	'Rhode Island' => 'RI',
  	'South Carolina' => 'SC',
  	'South Dakota' => 'SD',
  	'Tennessee' => 'TN',
  	'Texas' => 'TX',
  	'Utah' => 'UT',
  	'Vermont' => 'VT',
  	'Virginia' => 'VA',
  	'Washington' => 'WA',
  	'West Virginia' => 'WV',
  	'Wisconsin' => 'WI',
  	'Wyoming' => 'WY'
  }

  def self.get_author_location(author_url)
    page = Nokogiri::HTML(open(author_url, 'User-Agent' => 'chrome'))
    raw_location = page.css('div.profile-info .a-row.a-spacing-micro span.a-size-small.a-color-secondary').text.upcase
    if raw_location != ''
      state_short = LOCATION_HASH.values.select { |state| state if raw_location.include?(state) }
      state_full = LOCATION_HASH.keys.select { |state| state if raw_location.include?(state.upcase) }
      case
        when !state_short.empty? then location = state_short.first
        when !state_full.empty? then location = LOCATION_HASH[state_full.first]
        else location = 'Not Specified'
      end
    else
      location = 'Not Specified'
    end
  end
end
