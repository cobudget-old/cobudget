require 'cobudget/entities/budget'
require 'cobudget/entities/bucket'

module Cobudget
  class SeedLoader
    def self.load_seed
      budget = Cobudget::Budget.create(name: 'Budget')
      buckets = ["Sponsor Count Dracula to suck on some blood", "Website build", "Foundation magic bucket"]
      description = "We are aiming to raise around $5k in total by end of the year to pay Nanz (design) & Maz (dev) to refresh the design and build the site on wordpress. We have already raised $2,177 in previous collab funding rounds this year. Nanz volunteered her time to make the current changes to the squarespace site (details). $5k would give us each $50/hour for 50 hours ($2.5k each). We are charging commercial rates so that we can treat this as regular client work and block out chunks of our time to create a really beautifully designed and engaging website. That being said, we're happy to do it for whatever we can get via buckets as it would be great to have a website we're proud of, so happy to do it at a discounted rate if needs be. 

      Design
      - Redesign look & feel and overall visual concept of website while keeping general existing content structure in place as appropriate.
      - Design system for further categorisation of ventures vs service teams
      - Research on possibilities for interactive elements/ things that could make the site really engaging 
      - Adapt UI to new look and feel, design flats for all pages
      - Redesign blog for incorporation into new site 
      - Make logo assets for teams that don't have one. (Eg: freelancers, enspiral services)

      Dev
      - Build new design into a custom Wordpress theme to make the site easily updatable and adaptable for the future needs. 
      - Build out the admin section to further enhance the CMS so the site can be updated by non-tech folk.
      - Responsive styles for new design to make site mobile friendly
      - Build new blog to match new design
      - Migrate old blog content across to new site
      - Cross browser testing & fixes
      - Deploy"
      buckets.each do |b|
        Cobudget::Bucket.create(budget: budget, name: b, description: description, minimum: nil, maximum: nil, sponsor: nil)
      end
    end
  end
end

