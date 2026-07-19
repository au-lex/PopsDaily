import 'package:flutter/material.dart';
import 'package:news_app/model/news_model.dart';

final List<NewsArticle> mockBreakingNews = [
  const NewsArticle(
    title:
        'Unmasking the Truth: Investigative Report Exposes Widespread Political Corruption',
    description:
        'A deep-dive investigation reveals patterns of misconduct across state institutions.',
    body: '''
An extensive investigation spanning several months has uncovered a web of financial irregularities linking senior government officials to a series of undisclosed contracts. Documents obtained by reporters show payments routed through shell companies, raising questions about oversight failures at multiple levels of government.

Sources close to the matter say the findings have already prompted internal reviews within at least three state agencies. Opposition lawmakers are calling for an independent inquiry, while officials named in the report have denied any wrongdoing.

Analysts say the fallout could reshape public trust ahead of upcoming elections, with civil society groups demanding stronger transparency measures for public procurement going forward.
''',
    source: 'CNN News',
    sourceInitial: 'C',
    sourceColor: Color(0xffE63946),
    timeAgo: '3 days ago',
    views: '245.8K',
    comments: '3.2K',
    image: 'https://picsum.photos/seed/breaking1/700/500',
    category: 'Politics',
    isBookmarked: true,
  ),
  const NewsArticle(
    title: 'Breaking: New Trade Agreement Reshapes Regional Economy',
    description:
        'Leaders sign a landmark deal expected to boost cross-border commerce.',
    body: '''
Regional leaders have signed a sweeping trade agreement aimed at eliminating tariffs on key exports and simplifying customs procedures across member states. Officials say the deal could add billions in economic output over the next decade.

The agreement covers agriculture, manufacturing, and digital services, with provisions for phased implementation over five years. Business groups have largely welcomed the move, citing reduced costs and easier market access.

Critics, however, warn that smaller local industries may struggle to compete with an influx of cheaper imported goods, and are calling for transition support programs to cushion the impact.
''',
    source: 'USA Today',
    sourceInitial: 'U',
    sourceColor: Color(0xff2196F3),
    timeAgo: '2 days ago',
    views: '196.4K',
    comments: '1.8K',
    image: 'https://picsum.photos/seed/breaking2/700/500',
    category: 'Business',
    isBookmarked: false,
  ),
];

final List<NewsArticle> mockRecentStories = [
  const NewsArticle(
    title:
        'Revolutionizing the Future: Breakthrough Technology Set to Transform Industries',
    description:
        'New innovations promise to reshape manufacturing and logistics worldwide.',
    body: '''
A new wave of automation technology is being rolled out across manufacturing floors worldwide, promising faster production cycles and significant cost savings. Early adopters report efficiency gains of up to 30% within the first six months of deployment.

The technology combines robotics with real-time data analytics, allowing factories to predict maintenance needs before equipment failures occur. Logistics companies are also exploring similar systems to optimize warehouse operations and delivery routing.

Industry experts caution that the shift will require significant workforce retraining, as roles evolve from manual operation to system oversight and maintenance.
''',
    source: 'Jane Cooper',
    sourceInitial: 'J',
    sourceColor: Color(0xff9C6ADE),
    timeAgo: '1 min ago',
    views: '378',
    comments: '2',
    image: 'https://picsum.photos/seed/recent1/300/300',
    category: 'Technology',
    isBookmarked: false,
  ),
  const NewsArticle(
    title:
        'Economic Boom on the Horizon: Experts Predict Record Growth in Key Sectors',
    description:
        'Analysts point to strong indicators across manufacturing and tech.',
    body: '''
Economic forecasters are projecting record growth across several key sectors over the next fiscal year, driven by renewed investment in manufacturing, technology, and infrastructure. Consumer spending has also shown resilience despite ongoing global uncertainty.

Central bank officials note that inflation has stabilized in recent months, giving policymakers more room to support growth-oriented initiatives. Several major corporations have already announced expansion plans in response to the favorable outlook.

Not all analysts share the optimism, with some warning that global supply chain risks and geopolitical tensions could still disrupt momentum in the months ahead.
''',
    source: 'NBC News',
    sourceInitial: 'N',
    sourceColor: Colors.black,
    timeAgo: '2 mins ago',
    views: '852',
    comments: '3',
    image: 'https://picsum.photos/seed/recent2/300/300',
    category: 'Business',
    isBookmarked: false,
  ),
  const NewsArticle(
    title:
        'Breakthrough Discovery: Promising Treatment Shows Potential in Cancer Battle',
    description:
        'Researchers report encouraging early trial results for a new therapy.',
    body: '''
Researchers at a leading medical institute have reported encouraging results from an early-phase clinical trial testing a novel targeted therapy for aggressive forms of cancer. Patients in the trial showed significant tumor reduction with manageable side effects.

The treatment works by targeting specific proteins that allow cancer cells to evade the immune system, effectively making tumors more visible to the body's natural defenses. Researchers say larger trials are needed before the therapy can be considered for wider use.

Patient advocacy groups have welcomed the news cautiously, emphasizing that while early results are promising, it will likely be several years before the treatment becomes widely available.
''',
    source: 'Brooklyn Simmons',
    sourceInitial: 'B',
    sourceColor: Color(0xff2196F3),
    timeAgo: '3 mins ago',
    views: '1.2K',
    comments: '5',
    image: 'https://picsum.photos/seed/recent3/300/300',
    category: 'Technology',
    isBookmarked: true,
  ),
  const NewsArticle(
    title:
        'Innovation Unleashed: Groundbreaking Tech Unveiled at Global Summit',
    description:
        'Industry leaders showcase next-generation devices and platforms.',
    body: '''
Top technology firms took center stage at this year's global innovation summit, unveiling a range of next-generation devices and platforms aimed at reshaping how people work, communicate, and consume media.

Highlights included advances in wearable computing, energy-efficient chip design, and AI-powered productivity tools designed for both enterprise and everyday consumer use. Several companies also announced new partnerships aimed at accelerating adoption of these technologies.

Analysts say the announcements signal an increasingly competitive landscape, with major players racing to define the next generation of consumer technology standards.
''',
    source: 'BBC News',
    sourceInitial: 'B',
    sourceColor: Color(0xffE63946),
    timeAgo: '1 min ago',
    views: '1.3K',
    comments: '3',
    image: 'https://picsum.photos/seed/recent4/300/300',
    category: 'Technology',
    isBookmarked: false,
  ),
];
