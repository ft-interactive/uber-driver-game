export default (environment = 'development') => ({ // eslint-disable-line
  // eslint-disable-line

  // link file UUID
  id: '4a9f8b6e-a76d-11e7-ab55-27219df83c97',

  // canonical URL of the published page
  //  get filled in by the ./configure script
  url: 'https://ig.ft.com/uber-game',

  // To set an exact publish date do this:
  //       new Date('2016-05-17T17:11:22Z')
  publishedDate: new Date(),

  headline: 'The Uber Game',

  // summary === standfirst (Summary is what the content API calls it)
  summary:
    'Can you make it in the gig economy? ' +
    'Experience a week in the life of an Uber driver trying to make ends meet',

  topic: {
    name: 'Uber',
    url: 'https://www.ft.com/topics/organisations/Uber',
  },

  relatedArticle: {
    text: 'Related article »',
    url: 'https://www.ft.com/content/dfad68ca-a49d-11e7-b797-b61809486fe2',
  },

  mainImage: {
    title: 'The Uber Game',
    description: 'Cover image for the FT Uber game',
    credit: 'Rebecca Turner, FT',

    // You can provide a UUID to an image and it will populate everything else
    uuid: 'bf20a4f6-a82f-11e7-ab55-27219df83c97',

    // You can also provide a URL
    // url: 'https://image.webservices.ft.com/v1/images/raw/http%3A%2F%2Fcom.ft.imagepublish.prod.s3.amazonaws.com%2Fc4bf0be4-7c15-11e4-a7b8-00144feabdc0?source=ig&fit=scale-down&width=700',
  },

  // Byline can by a plain string, markdown, or array of authors
  // if array of authors, url is optional
  byline: [{ name: 'Robin Kwong' }, { name: 'Leslie Hook' }, { name: 'David Blood' }, { name: 'Rebecca Turner' }, { name: 'Callum Locke' }, { name: 'Ændrew Rininsland' }, { name: 'Nicolai Knoll' }, { name: 'Joanna Kao' }],

  // Appears in the HTML <title>
  title: 'The Uber Game',

  // meta data
  description: 'A news game based on interviews with dozens of Uber drivers.',

  /*
  TODO: Select Twitter card type -
        summary or summary_large_image

        Twitter card docs:
        https://dev.twitter.com/cards/markup
  */
  twitterCard: 'summary_large_image',

  /*
  TODO: Do you want to tweak any of the
        optional social meta data?
  */
  // General social
  socialImage: 'https://www.ft.com/__origami/service/image/v2/images/raw/http%3A%2F%2Fim.ft-static.com%2Fcontent%2Fimages%2Fbf20a4f6-a82f-11e7-ab55-27219df83c97.img?source=ig',
  socialHeadline: 'The Uber Game: Can you make it in the gig economy?',
  socialDescription: 'A news game based on interviews with dozens of Uber drivers',
  twitterCreator: '@FT', // shows up in summary_large_image cards

  // TWEET BUTTON CUSTOM TEXT
  tweetText: 'Could you make it as an Uber driver? Try the FT news game',
  //
  // Twitter lists these as suggested accounts to follow after a user tweets (do not include @)
  // twitterRelatedAccounts: ['authors_account_here', 'ftdata'],

  // Fill out the Facebook/Twitter metadata sections below if you want to
  // override the General social options above

  // TWITTER METADATA (for Twitter cards)
  twitterImage: 'https://www.ft.com/__origami/service/image/v2/images/raw/http%3A%2F%2Fim.ft-static.com%2Fcontent%2Fimages%2Fbf20a4f6-a82f-11e7-ab55-27219df83c97.img?source=ig',
  twitterHeadline: 'The Uber Game',
  twitterDescription: 'Can you make it in the gig economy?',

  // FACEBOOK
  facebookImage: 'https://www.ft.com/__origami/service/image/v2/images/raw/http%3A%2F%2Fim.ft-static.com%2Fcontent%2Fimages%2Fbf20a4f6-a82f-11e7-ab55-27219df83c97.img?source=ig',
  facebookHeadline: 'Could you make it as an Uber driver?',
  facebookDescription: 'A news game based on interviews with dozens of Uber drivers',

  // ADVERTISING
  ads: {
    // Ad unit hierarchy makes ads more granular.
    gptSite: 'ft.com',
    // Start with ft.com and /companies /markets /world as appropriate to your story
    gptZone: false,
    // granular targeting is optional and will be specified by the ads team
    dfpTargeting: false,
  },

  tracking: {
    /*

    Microsite Name

    e.g. guffipedia, business-books, baseline.
    Used to query groups of pages, not intended for use with
    one off interactive pages. If you're building a microsite
    consider more custom tracking to allow better analysis.
    Also used for pages that do not have a UUID for whatever reason
    */
    // micrositeName: '',
    /*
    Product name

    This will usually default to IG
    however another value may be needed
    */
    // product: '',
  },
});
