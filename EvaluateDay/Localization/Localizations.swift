// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum Localizations {

  internal enum Accessibility {
    /// Current value is %@
    internal static func current(_ p1: String) -> String {
      return Localizations.tr("Localizable", "accessibility.current", p1)
    }
    /// Double tap to select new date
    internal static let date = Localizations.tr("Localizable", "accessibility.date")
    /// less
    internal static let less = Localizations.tr("Localizable", "accessibility.less")
    /// more
    internal static let more = Localizations.tr("Localizable", "accessibility.more")
    /// Previous value is %@
    internal static func previous(_ p1: String) -> String {
      return Localizations.tr("Localizable", "accessibility.previous", p1)
    }
    /// selected
    internal static let selected = Localizations.tr("Localizable", "accessibility.selected")
    /// unselected
    internal static let unselected = Localizations.tr("Localizable", "accessibility.unselected")
    internal enum Activity {
      internal enum PersonalInformation {
        /// biography
        internal static let bio = Localizations.tr("Localizable", "accessibility.activity.personalInformation.bio")
        /// Edit personal information
        internal static let edit = Localizations.tr("Localizable", "accessibility.activity.personalInformation.edit")
        /// email
        internal static let email = Localizations.tr("Localizable", "accessibility.activity.personalInformation.email")
        /// Select personal photo
        internal static let image = Localizations.tr("Localizable", "accessibility.activity.personalInformation.image")
        /// Name
        internal static let name = Localizations.tr("Localizable", "accessibility.activity.personalInformation.name")
        /// Save personal information
        internal static let save = Localizations.tr("Localizable", "accessibility.activity.personalInformation.save")
        /// site
        internal static let site = Localizations.tr("Localizable", "accessibility.activity.personalInformation.site")
      }
    }
    internal enum Analytics {
      /// Bar Chart
      internal static let barChart = Localizations.tr("Localizable", "accessibility.analytics.barChart")
      /// Bar chart have %@ entries
      internal static func barChartData(_ p1: String) -> String {
        return Localizations.tr("Localizable", "accessibility.analytics.barChartData", p1)
      }
      /// Calendar view
      internal static let calendarView = Localizations.tr("Localizable", "accessibility.analytics.calendarView")
      /// Color %@ marked in %@ days
      internal static func color(_ p1: String, _ p2: String) -> String {
        return Localizations.tr("Localizable", "accessibility.analytics.color", p1, p2)
      }
      /// Line Chart
      internal static let lineChart = Localizations.tr("Localizable", "accessibility.analytics.lineChart")
      /// Line chart have %@ entries
      internal static func lineChartData(_ p1: String) -> String {
        return Localizations.tr("Localizable", "accessibility.analytics.lineChartData", p1)
      }
      /// Map view
      internal static let mapView = Localizations.tr("Localizable", "accessibility.analytics.mapView")
      /// Open Analytics
      internal static let `open` = Localizations.tr("Localizable", "accessibility.analytics.open")
      /// Share statistic
      internal static let shareStat = Localizations.tr("Localizable", "accessibility.analytics.shareStat")
      internal enum Export {
        /// Double tap to export
        internal static let hint = Localizations.tr("Localizable", "accessibility.analytics.export.hint")
        /// Export data to %@ file
        internal static func title(_ p1: String) -> String {
          return Localizations.tr("Localizable", "accessibility.analytics.export.title", p1)
        }
      }
    }
    internal enum Collection {
      /// Collection - %@
      internal static func collection(_ p1: String) -> String {
        return Localizations.tr("Localizable", "accessibility.collection.collection", p1)
      }
      /// Edit Collection
      internal static let edit = Localizations.tr("Localizable", "accessibility.collection.edit")
      /// Double Tap to select new image
      internal static let editImage = Localizations.tr("Localizable", "accessibility.collection.editImage")
      /// Card - %@,  in collection - %@
      internal static func `override`(_ p1: String, _ p2: String) -> String {
        return Localizations.tr("Localizable", "accessibility.collection.override", p1, p2)
      }
    }
    internal enum Evaluate {
      /// %@, marked locations - %i
      internal static func checkIn(_ p1: String, _ p2: Int) -> String {
        return Localizations.tr("Localizable", "accessibility.evaluate.checkIn", p1, p2)
      }
      /// Edit phrase per %@
      internal static func phraseEdit(_ p1: String) -> String {
        return Localizations.tr("Localizable", "accessibility.evaluate.phraseEdit", p1)
      }
      /// Reorder Cards
      internal static let reorder = Localizations.tr("Localizable", "accessibility.evaluate.reorder")
      internal enum Counter {
        /// Decrease counter with step - %@
        internal static func decrease(_ p1: String) -> String {
          return Localizations.tr("Localizable", "accessibility.evaluate.counter.decrease", p1)
        }
        /// Increase counter with step - %@
        internal static func increase(_ p1: String) -> String {
          return Localizations.tr("Localizable", "accessibility.evaluate.counter.increase", p1)
        }
        /// Current counter value is - %@ at %@, previous value was - %@
        internal static func summory(_ p1: String, _ p2: String, _ p3: String) -> String {
          return Localizations.tr("Localizable", "accessibility.evaluate.counter.summory", p1, p2, p3)
        }
        /// Sum of counter is - %@
        internal static func summorySum(_ p1: String) -> String {
          return Localizations.tr("Localizable", "accessibility.evaluate.counter.summorySum", p1)
        }
      }
      internal enum Criterion {
        /// Double tap to evaluate per %@
        internal static func hint(_ p1: String) -> String {
          return Localizations.tr("Localizable", "accessibility.evaluate.criterion.hint", p1)
        }
        /// negative
        internal static let negative = Localizations.tr("Localizable", "accessibility.evaluate.criterion.negative")
        /// positive
        internal static let positive = Localizations.tr("Localizable", "accessibility.evaluate.criterion.positive")
        /// Current value at %@ is %@, on %@ %@ than previous value. Previous value is %@
        internal static func value(_ p1: String, _ p2: String, _ p3: String, _ p4: String, _ p5: String) -> String {
          return Localizations.tr("Localizable", "accessibility.evaluate.criterion.value", p1, p2, p3, p4, p5)
        }
        internal enum Three {
          /// bad
          internal static let bad = Localizations.tr("Localizable", "accessibility.evaluate.criterion.three.bad")
          /// good
          internal static let good = Localizations.tr("Localizable", "accessibility.evaluate.criterion.three.good")
          /// neutral
          internal static let neutral = Localizations.tr("Localizable", "accessibility.evaluate.criterion.three.neutral")
        }
      }
      internal enum Goal {
        /// Decrease goal counter with step - %@
        internal static func decrease(_ p1: String) -> String {
          return Localizations.tr("Localizable", "accessibility.evaluate.goal.decrease", p1)
        }
        /// Increase goal counter with step - %@
        internal static func increase(_ p1: String) -> String {
          return Localizations.tr("Localizable", "accessibility.evaluate.goal.increase", p1)
        }
        /// Current goal counter value is - %@ at %@, previous value was - %@
        internal static func summory(_ p1: String, _ p2: String, _ p3: String) -> String {
          return Localizations.tr("Localizable", "accessibility.evaluate.goal.summory", p1, p2, p3)
        }
        /// Sum of goal counter is - %@
        internal static func summorySum(_ p1: String) -> String {
          return Localizations.tr("Localizable", "accessibility.evaluate.goal.summorySum", p1)
        }
      }
      internal enum Habit {
        /// Double tap to edit the comment
        internal static let commentHint = Localizations.tr("Localizable", "accessibility.evaluate.habit.commentHint")
        /// Number of marks is - %@ at %@, previous number was - %@
        internal static func summory(_ p1: String, _ p2: String, _ p3: String) -> String {
          return Localizations.tr("Localizable", "accessibility.evaluate.habit.summory", p1, p2, p3)
        }
      }
      internal enum Journal {
        /// Double tap to edit entry
        internal static let entryHint = Localizations.tr("Localizable", "accessibility.evaluate.journal.entryHint")
        /// Entry with photo
        internal static let entryPhoto = Localizations.tr("Localizable", "accessibility.evaluate.journal.entryPhoto")
        /// Add new entry at %@
        internal static func newEntry(_ p1: String) -> String {
          return Localizations.tr("Localizable", "accessibility.evaluate.journal.newEntry", p1)
        }
        /// %@, number of entries - %i
        internal static func value(_ p1: String, _ p2: Int) -> String {
          return Localizations.tr("Localizable", "accessibility.evaluate.journal.value", p1, p2)
        }
        internal enum Entry {
          /// Double tap to action
          internal static let actionHint = Localizations.tr("Localizable", "accessibility.evaluate.journal.entry.actionHint")
          /// Delete Photo
          internal static let deletePhoto = Localizations.tr("Localizable", "accessibility.evaluate.journal.entry.deletePhoto")
          /// Double tap to edit text
          internal static let editTextHint = Localizations.tr("Localizable", "accessibility.evaluate.journal.entry.editTextHint")
          /// Open Camera
          internal static let openCamera = Localizations.tr("Localizable", "accessibility.evaluate.journal.entry.openCamera")
          /// Open Gallery
          internal static let openGalery = Localizations.tr("Localizable", "accessibility.evaluate.journal.entry.openGalery")
          /// View photo
          internal static let viewPhoto = Localizations.tr("Localizable", "accessibility.evaluate.journal.entry.viewPhoto")
        }
      }
      internal enum List {
        /// Add new item in list
        internal static let addNew = Localizations.tr("Localizable", "accessibility.evaluate.list.addNew")
        /// %@ done - %@ of %@ - %@ and per all time done %@ of %@ - %@
        internal static func allDone(_ p1: String, _ p2: String, _ p3: String, _ p4: String, _ p5: String, _ p6: String, _ p7: String) -> String {
          return Localizations.tr("Localizable", "accessibility.evaluate.list.allDone", p1, p2, p3, p4, p5, p6, p7)
        }
        /// checkbox
        internal static let checkbox = Localizations.tr("Localizable", "accessibility.evaluate.list.checkbox")
        /// Double tap to mark as %@
        internal static func checkboxHint(_ p1: String) -> String {
          return Localizations.tr("Localizable", "accessibility.evaluate.list.checkboxHint", p1)
        }
        /// completed
        internal static let completed = Localizations.tr("Localizable", "accessibility.evaluate.list.completed")
        /// %@ done - %@
        internal static func done(_ p1: String, _ p2: String) -> String {
          return Localizations.tr("Localizable", "accessibility.evaluate.list.done", p1, p2)
        }
        /// Double tap to edit item
        internal static let editItemHint = Localizations.tr("Localizable", "accessibility.evaluate.list.editItemHint")
        /// Edit list
        internal static let editList = Localizations.tr("Localizable", "accessibility.evaluate.list.editList")
        /// uncompleted
        internal static let uncompleted = Localizations.tr("Localizable", "accessibility.evaluate.list.uncompleted")
      }
      internal enum Map {
        /// Current Location
        internal static let location = Localizations.tr("Localizable", "accessibility.evaluate.map.location")
        /// Double tap to select and save location
        internal static let locationSelect = Localizations.tr("Localizable", "accessibility.evaluate.map.locationSelect")
        /// Double tap to save search
        internal static let search = Localizations.tr("Localizable", "accessibility.evaluate.map.search")
      }
    }
    internal enum Notification {
      /// notification with the message: %@, repeat: %@, at %@, with the card: %@
      internal static func description(_ p1: String, _ p2: String, _ p3: String, _ p4: String) -> String {
        return Localizations.tr("Localizable", "accessibility.notification.description", p1, p2, p3, p4)
      }
    }
    internal enum Pro {
      /// Conrol Evaluate Day subscription status
      internal static let `open` = Localizations.tr("Localizable", "accessibility.pro.open")
    }
  }

  internal enum Activity {
    /// Activity feed
    internal static let title = Localizations.tr("Localizable", "activity.title")
    internal enum Analytics {
      internal enum Barchart {
        /// Statistics of launches
        internal static let title = Localizations.tr("Localizable", "activity.analytics.barchart.title")
      }
      internal enum Stat {
        /// Days
        internal static let alldays = Localizations.tr("Localizable", "activity.analytics.stat.alldays")
        /// Archived
        internal static let archived = Localizations.tr("Localizable", "activity.analytics.stat.archived")
        /// Cards
        internal static let cards = Localizations.tr("Localizable", "activity.analytics.stat.cards")
        /// Statistics
        internal static let description = Localizations.tr("Localizable", "activity.analytics.stat.description")
        /// Start using the app
        internal static let firsStartDate = Localizations.tr("Localizable", "activity.analytics.stat.firsStartDate")
        /// About app
        internal static let subtitle = Localizations.tr("Localizable", "activity.analytics.stat.subtitle")
        /// Detail statistics
        internal static let title = Localizations.tr("Localizable", "activity.analytics.stat.title")
        /// Total starts
        internal static let totalStarts = Localizations.tr("Localizable", "activity.analytics.stat.totalStarts")
        /// Last update
        internal static let updateDate = Localizations.tr("Localizable", "activity.analytics.stat.updateDate")
        /// Current version
        internal static let version = Localizations.tr("Localizable", "activity.analytics.stat.version")
      }
    }
    internal enum Gallery {
      /// Show all photos
      internal static let allPhotos = Localizations.tr("Localizable", "activity.gallery.allPhotos")
      /// Unlock Evaluate Day Pro to see gallery
      internal static let subtitle = Localizations.tr("Localizable", "activity.gallery.subtitle")
      /// Gallery
      internal static let title = Localizations.tr("Localizable", "activity.gallery.title")
    }
    internal enum User {
      internal enum Facebook {
        /// Update from Facebook
        internal static let action = Localizations.tr("Localizable", "activity.user.facebook.action")
        /// We never post on Facebook.
        internal static let disclaimer = Localizations.tr("Localizable", "activity.user.facebook.disclaimer")
      }
      internal enum Placeholder {
        /// Introduce yourself
        internal static let bio = Localizations.tr("Localizable", "activity.user.placeholder.bio")
        /// Set email
        internal static let email = Localizations.tr("Localizable", "activity.user.placeholder.email")
        /// Set full name
        internal static let name = Localizations.tr("Localizable", "activity.user.placeholder.name")
        /// Your web site
        internal static let web = Localizations.tr("Localizable", "activity.user.placeholder.web")
      }
    }
  }

  internal enum Analytics {
    /// Analytics
    internal static let action = Localizations.tr("Localizable", "analytics.action")
    /// Time Travel
    internal static let timeTravel = Localizations.tr("Localizable", "analytics.timeTravel")
    /// Analytics
    internal static let title = Localizations.tr("Localizable", "analytics.title")
    internal enum Chart {
      internal enum Bar {
        internal enum Criterion {
          /// All data
          internal static let title = Localizations.tr("Localizable", "analytics.chart.bar.criterion.title")
        }
      }
      internal enum Line {
        internal enum Criterion {
          /// Data by all time
          internal static let title = Localizations.tr("Localizable", "analytics.chart.line.criterion.title")
        }
      }
    }
    internal enum Checkin {
      internal enum Calendar {
        /// Days for which a location was marked
        internal static let title = Localizations.tr("Localizable", "analytics.checkin.calendar.title")
      }
      internal enum Map {
        /// View all on map
        internal static let action = Localizations.tr("Localizable", "analytics.checkin.map.action")
        /// Nearest marks
        internal static let title = Localizations.tr("Localizable", "analytics.checkin.map.title")
      }
    }
    internal enum Color {
      internal enum Calendar {
        /// Colors by days
        internal static let title = Localizations.tr("Localizable", "analytics.color.calendar.title")
      }
    }
    internal enum Export {
      /// Tap to export
      internal static let action = Localizations.tr("Localizable", "analytics.export.action")
      /// Export Data
      internal static let title = Localizations.tr("Localizable", "analytics.export.title")
    }
    internal enum Habit {
      /// Marks
      internal static let marks = Localizations.tr("Localizable", "analytics.habit.marks")
      internal enum Calendar {
        /// Days for which a habit was marked
        internal static let title = Localizations.tr("Localizable", "analytics.habit.calendar.title")
      }
    }
    internal enum Journal {
      /// Number of entries by day
      internal static let barEntries = Localizations.tr("Localizable", "analytics.journal.barEntries")
      /// Nearest entries
      internal static let near = Localizations.tr("Localizable", "analytics.journal.near")
      /// View all
      internal static let viewAll = Localizations.tr("Localizable", "analytics.journal.viewAll")
    }
    internal enum List {
      /// Items
      internal static let items = Localizations.tr("Localizable", "analytics.list.items")
      /// Done
      internal static let itemsDone = Localizations.tr("Localizable", "analytics.list.itemsDone")
      /// Percent
      internal static let percent = Localizations.tr("Localizable", "analytics.list.percent")
    }
    internal enum Phrase {
      /// View all phrases
      internal static let viewAll = Localizations.tr("Localizable", "analytics.phrase.viewAll")
      internal enum Calendar {
        /// Days for which entries were made
        internal static let title = Localizations.tr("Localizable", "analytics.phrase.calendar.title")
      }
    }
    internal enum Statistics {
      /// Average
      internal static let average = Localizations.tr("Localizable", "analytics.statistics.average")
      /// Check In
      internal static let checkins = Localizations.tr("Localizable", "analytics.statistics.checkins")
      /// Days
      internal static let days = Localizations.tr("Localizable", "analytics.statistics.days")
      /// Entries
      internal static let entries = Localizations.tr("Localizable", "analytics.statistics.entries")
      /// Maximum
      internal static let maximum = Localizations.tr("Localizable", "analytics.statistics.maximum")
      /// Minimum
      internal static let minimum = Localizations.tr("Localizable", "analytics.statistics.minimum")
      /// Sum
      internal static let sum = Localizations.tr("Localizable", "analytics.statistics.sum")
      /// Information
      internal static let title = Localizations.tr("Localizable", "analytics.statistics.title")
      internal enum Characters {
        /// Average characters
        internal static let average = Localizations.tr("Localizable", "analytics.statistics.characters.average")
        /// Maximum characters
        internal static let max = Localizations.tr("Localizable", "analytics.statistics.characters.max")
        /// Minimum characters
        internal static let min = Localizations.tr("Localizable", "analytics.statistics.characters.min")
        /// Characters
        internal static let total = Localizations.tr("Localizable", "analytics.statistics.characters.total")
      }
      internal enum Color {
        /// Frequency of colours use
        internal static let title = Localizations.tr("Localizable", "analytics.statistics.color.title")
      }
    }
    internal enum Tracker {
      internal enum Calendar {
        /// Days for which a tracker was marked
        internal static let title = Localizations.tr("Localizable", "analytics.tracker.calendar.title")
      }
    }
  }

  internal enum Calendar {
    /// Evaluate
    internal static let openEvaluate = Localizations.tr("Localizable", "calendar.openEvaluate")
    /// Open
    internal static let viewEvaluate = Localizations.tr("Localizable", "calendar.viewEvaluate")
    internal enum Checkin {
      /// You haven't been anywhere yet
      internal static let noTitle = Localizations.tr("Localizable", "calendar.checkin.noTitle")
      /// Marks - %@
      internal static func title(_ p1: String) -> String {
        return Localizations.tr("Localizable", "calendar.checkin.title", p1)
      }
    }
    internal enum Counter {
      /// %@ (in this day: %@)
      internal static func sum(_ p1: String, _ p2: String) -> String {
        return Localizations.tr("Localizable", "calendar.counter.sum", p1, p2)
      }
    }
    internal enum Empty {
      /// Evaluate: %@
      internal static func openEvaluate(_ p1: String) -> String {
        return Localizations.tr("Localizable", "calendar.empty.openEvaluate", p1)
      }
      /// Share
      internal static let share = Localizations.tr("Localizable", "calendar.empty.share")
      /// Open: %@
      internal static func viewEvaluate(_ p1: String) -> String {
        return Localizations.tr("Localizable", "calendar.empty.viewEvaluate", p1)
      }
      internal enum FutureQuote {
        /// Audrey Hepburn
        internal static let author = Localizations.tr("Localizable", "calendar.empty.futureQuote.author")
        /// «Nothing is impossible, the word itself says, I’m possible!»
        internal static let text = Localizations.tr("Localizable", "calendar.empty.futureQuote.text")
      }
    }
    internal enum Journal {
      /// Entries - %@
      internal static func title(_ p1: String) -> String {
        return Localizations.tr("Localizable", "calendar.journal.title", p1)
      }
    }
    internal enum List {
      /// Total %@ (in this day %@ (%@)). Done %@
      internal static func info(_ p1: String, _ p2: String, _ p3: String, _ p4: String) -> String {
        return Localizations.tr("Localizable", "calendar.list.info", p1, p2, p3, p4)
      }
    }
  }

  internal enum CardMerge {
    /// Merge
    internal static let action = Localizations.tr("Localizable", "cardMerge.action")
    /// Base Card
    internal static let baseCard = Localizations.tr("Localizable", "cardMerge.baseCard")
    /// You can`t UNDO merge
    internal static let disclaimer = Localizations.tr("Localizable", "cardMerge.disclaimer")
    /// Base card data remains
    internal static let mergeByBaseCard = Localizations.tr("Localizable", "cardMerge.mergeByBaseCard")
    /// The most recent data remains
    internal static let mergeByDate = Localizations.tr("Localizable", "cardMerge.mergeByDate")
    /// Choose how to combine similar data, and which card you want to merge with the main one. After the cards are merged, the second card will be deleted.
    internal static let mergeTypeDescription = Localizations.tr("Localizable", "cardMerge.mergeTypeDescription")
    /// You must select other card
    internal static let mustSelect = Localizations.tr("Localizable", "cardMerge.mustSelect")
    /// Select other card
    internal static let selectCard = Localizations.tr("Localizable", "cardMerge.selectCard")
    /// Merge Cards
    internal static let title = Localizations.tr("Localizable", "cardMerge.title")
  }

  internal enum CardSettings {
    /// Danger Zone
    internal static let dangerZone = Localizations.tr("Localizable", "cardSettings.dangerZone")
    /// Subtitle
    internal static let subtitle = Localizations.tr("Localizable", "cardSettings.subtitle")
    /// Tap to enter new
    internal static let textPlaceholder = Localizations.tr("Localizable", "cardSettings.textPlaceholder")
    /// Title
    internal static let title = Localizations.tr("Localizable", "cardSettings.title")
    /// Untitled %@
    internal static func untitle(_ p1: String) -> String {
      return Localizations.tr("Localizable", "cardSettings.untitle", p1)
    }
    internal enum Counter {
      /// Initial value
      internal static let start = Localizations.tr("Localizable", "cardSettings.counter.start")
      /// Step
      internal static let step = Localizations.tr("Localizable", "cardSettings.counter.step")
      internal enum Sum {
        /// Total values ​​for the days
        internal static let title = Localizations.tr("Localizable", "cardSettings.counter.sum.title")
      }
    }
    internal enum Criterion {
      internal enum Feater {
        /// Criteria can be positive and negative. For positive criteria, the higher the value, the better; for negative - on the contrary. Fatigue, for example, is a negative criterion.
        internal static let description = Localizations.tr("Localizable", "cardSettings.criterion.feater.description")
        /// Positive
        internal static let title = Localizations.tr("Localizable", "cardSettings.criterion.feater.title")
      }
    }
    internal enum General {
      /// Card Settings
      internal static let title = Localizations.tr("Localizable", "cardSettings.general.title")
    }
    internal enum Goal {
      /// Goal
      internal static let goal = Localizations.tr("Localizable", "cardSettings.goal.goal")
    }
    internal enum Habit {
      /// Multiple repetitions per day
      internal static let description = Localizations.tr("Localizable", "cardSettings.habit.description")
      /// Multiple
      internal static let multiple = Localizations.tr("Localizable", "cardSettings.habit.multiple")
      internal enum Negative {
        /// The less often you note bad habits, the better.
        internal static let description = Localizations.tr("Localizable", "cardSettings.habit.negative.description")
        /// Negative
        internal static let title = Localizations.tr("Localizable", "cardSettings.habit.negative.title")
      }
    }
    internal enum Health {
      /// Apple Health Metrics
      internal static let appleMetrics = Localizations.tr("Localizable", "cardSettings.health.appleMetrics")
      /// Metrics
      internal static let metrics = Localizations.tr("Localizable", "cardSettings.health.metrics")
    }
  }

  internal enum Collection {
    /// New Collection
    internal static let addNew = Localizations.tr("Localizable", "collection.addNew")
    /// All Cards
    internal static let allcards = Localizations.tr("Localizable", "collection.allcards")
    /// This action deletes the only collection. Cards will not be deleted. You can delete or archive card from card settings.
    internal static let deleteMessage = Localizations.tr("Localizable", "collection.deleteMessage")
    /// Icons
    internal static let icons = Localizations.tr("Localizable", "collection.icons")
    /// Title
    internal static let selectTitle = Localizations.tr("Localizable", "collection.selectTitle")
    /// Collections
    internal static let title = Localizations.tr("Localizable", "collection.title")
    /// Collection Title
    internal static let titlePlaceholder = Localizations.tr("Localizable", "collection.titlePlaceholder")
    internal enum Analytics {
      /// Cards
      internal static let cards = Localizations.tr("Localizable", "collection.analytics.cards")
      /// Created
      internal static let created = Localizations.tr("Localizable", "collection.analytics.created")
    }
    internal enum Edit {
      /// Tap to edit...
      internal static let image = Localizations.tr("Localizable", "collection.edit.image")
      /// Collection
      internal static let title = Localizations.tr("Localizable", "collection.edit.title")
      /// Untitled collection
      internal static let titlePlaceholder = Localizations.tr("Localizable", "collection.edit.titlePlaceholder")
      internal enum AddCard {
        /// This card in other collection. Do change the collection?
        internal static let message = Localizations.tr("Localizable", "collection.edit.addCard.message")
        /// Add Card
        internal static let title = Localizations.tr("Localizable", "collection.edit.addCard.title")
      }
      internal enum DeleteCard {
        /// Tap on the card to delete it from the collection
        internal static let footer = Localizations.tr("Localizable", "collection.edit.deleteCard.footer")
        /// It deletes an only card from the collection
        internal static let message = Localizations.tr("Localizable", "collection.edit.deleteCard.message")
      }
    }
    internal enum Empty {
      /// Add into the collection
      internal static let cardSetting = Localizations.tr("Localizable", "collection.empty.cardSetting")
      /// You have not card in collection yet. Add card in card settings.
      internal static let subtitle = Localizations.tr("Localizable", "collection.empty.subtitle")
      /// The collection is empty
      internal static let title = Localizations.tr("Localizable", "collection.empty.title")
    }
  }

  internal enum Default {
    internal enum Data {
      internal enum Phrase {
        /// Cards can help you track different indicators of your day. Find out more about the available types of cards at the "Add a new card" screen.\nHead to the analytics section to read all the notes.
        internal static let one = Localizations.tr("Localizable", "default.data.phrase.one")
        /// Add cards freely, sort them to your liking. Add a reminder.
        internal static let three = Localizations.tr("Localizable", "default.data.phrase.three")
        /// Press the card to open its settings, delete it or connect to any other similar card.
        internal static let two = Localizations.tr("Localizable", "default.data.phrase.two")
      }
    }
  }

  internal enum Demo {
    internal enum Counter {
      /// Cups of coffee ☕️
      internal static let subtitle = Localizations.tr("Localizable", "demo.counter.subtitle")
      /// Coffee ☕️
      internal static let title = Localizations.tr("Localizable", "demo.counter.title")
    }
    internal enum Criterion {
      internal enum Hundred {
        /// Was your day productive?
        internal static let subtitle = Localizations.tr("Localizable", "demo.criterion.hundred.subtitle")
        /// Productivity
        internal static let title = Localizations.tr("Localizable", "demo.criterion.hundred.title")
      }
      internal enum Ten {
        /// Am I really tired today?
        internal static let subtitle = Localizations.tr("Localizable", "demo.criterion.ten.subtitle")
        /// Tiredness
        internal static let title = Localizations.tr("Localizable", "demo.criterion.ten.title")
      }
      internal enum Three {
        /// My daily mood
        internal static let subtitle = Localizations.tr("Localizable", "demo.criterion.three.subtitle")
        /// Mood
        internal static let title = Localizations.tr("Localizable", "demo.criterion.three.title")
      }
    }
    internal enum Dashboard {
      /// Work
      internal static let work = Localizations.tr("Localizable", "demo.dashboard.work")
      /// Workout
      internal static let workout = Localizations.tr("Localizable", "demo.dashboard.workout")
    }
    internal enum Goal {
      /// Desired number of push-ups per day
      internal static let subtitle = Localizations.tr("Localizable", "demo.goal.subtitle")
      /// Push-ups per day
      internal static let title = Localizations.tr("Localizable", "demo.goal.title")
    }
    internal enum Habit {
      /// Write something everyday
      internal static let subtitle = Localizations.tr("Localizable", "demo.habit.subtitle")
      /// Write to the journal
      internal static let title = Localizations.tr("Localizable", "demo.habit.title")
    }
    internal enum Journal {
      /// USE IT ON ALL iOS DEVICES \nEvaluate Day works on iPhone and iPad, so you will be able to record changes in the cards. No matter where you are, create lists or add notes to your journal.
      internal static let entryFour = Localizations.tr("Localizable", "demo.journal.entryFour")
      /// Evaluate Day is an elegant and flexible application for tracking any parameters of your life, for keeping journals and conducting analyses of all indicators.
      internal static let entryOne = Localizations.tr("Localizable", "demo.journal.entryOne")
      /// ANALYTICAL INSTRUMENTS AND EXPORTING \nEvaluate Day’s simple instruments make the analytic process easy and convenient. You immediately see changes and can correct your actions. Data gathered using Evaluate Day belong only to you, so you can export them into CSV, TXT or JSON files and analyze them more in detail using any software that is convenient for you.
      internal static let entryThree = Localizations.tr("Localizable", "demo.journal.entryThree")
      /// EVERYTHING UNDER CONTROL \n Create your unique set of cards, sort them however you like and record all the changes every day. You will get an objective picture of your progress; you will clearly understand all changes and will be able to make timely corrections.
      internal static let entryTwo = Localizations.tr("Localizable", "demo.journal.entryTwo")
      /// All the interesting events of the day
      internal static let subtitle = Localizations.tr("Localizable", "demo.journal.subtitle")
      /// Everyday diary
      internal static let title = Localizations.tr("Localizable", "demo.journal.title")
    }
    internal enum List {
      /// Steps needed to put together a printer
      internal static let subtitle = Localizations.tr("Localizable", "demo.list.subtitle")
      /// Complete the assembly of the 3D printer
      internal static let title = Localizations.tr("Localizable", "demo.list.title")
      internal enum Steps {
        /// Print the first model
        internal static let fifth = Localizations.tr("Localizable", "demo.list.steps.fifth")
        /// Assemble the case
        internal static let first = Localizations.tr("Localizable", "demo.list.steps.first")
        /// Testing
        internal static let fourth = Localizations.tr("Localizable", "demo.list.steps.fourth")
        /// Assemble electronics
        internal static let second = Localizations.tr("Localizable", "demo.list.steps.second")
        /// Configure the program
        internal static let third = Localizations.tr("Localizable", "demo.list.steps.third")
      }
    }
    internal enum Phrase {
      /// Archiving of unused cards. With deletion, you lose all your data; with archiving, the card stays with you, and you will always be able to return to it or view it.
      internal static let dayFour = Localizations.tr("Localizable", "demo.phrase.dayFour")
      /// Create your unique set of cards, sort them however you like and record all the changes every day.
      internal static let dayOne = Localizations.tr("Localizable", "demo.phrase.dayOne")
      /// Evaluate Day works on iPhone and iPad, so you will be able to record changes in the cards. No matter where you are, create lists or add notes to your journal.
      internal static let dayThree = Localizations.tr("Localizable", "demo.phrase.dayThree")
      /// Evaluate Day’s simple instruments make the analytic process easy and convenient.
      internal static let dayTwo = Localizations.tr("Localizable", "demo.phrase.dayTwo")
    }
    internal enum Tracker {
      /// Do I take medication often?
      internal static let subtitle = Localizations.tr("Localizable", "demo.tracker.subtitle")
      /// Medication
      internal static let title = Localizations.tr("Localizable", "demo.tracker.title")
    }
  }

  internal enum Evaluate {
    internal enum Checkin {
      /// Quick Check In
      internal static let quickCheckin = Localizations.tr("Localizable", "evaluate.checkin.quickCheckin")
      /// Select on map
      internal static let showMap = Localizations.tr("Localizable", "evaluate.checkin.showMap")
      internal enum Permission {
        /// Allow location access
        internal static let buttonTitle = Localizations.tr("Localizable", "evaluate.checkin.permission.buttonTitle")
        /// For check in you must allow Evaluate Day use your location information
        internal static let description = Localizations.tr("Localizable", "evaluate.checkin.permission.description")
      }
    }
    internal enum Counter {
      /// Enter value
      internal static let customValue = Localizations.tr("Localizable", "evaluate.counter.customValue")
      /// Total amount of the counter - %@
      internal static func sum(_ p1: String) -> String {
        return Localizations.tr("Localizable", "evaluate.counter.sum", p1)
      }
    }
    internal enum Habit {
      /// Mark
      internal static let mark = Localizations.tr("Localizable", "evaluate.habit.mark")
      /// Mark and Comment
      internal static let markAndComment = Localizations.tr("Localizable", "evaluate.habit.markAndComment")
      /// Negative Habit
      internal static let negative = Localizations.tr("Localizable", "evaluate.habit.negative")
      /// Remove Last
      internal static let removeLast = Localizations.tr("Localizable", "evaluate.habit.removeLast")
    }
    internal enum Journal {
      /// New entry
      internal static let newEntry = Localizations.tr("Localizable", "evaluate.journal.newEntry")
      internal enum Entry {
        /// What`s on your mind?
        internal static let placeholder = Localizations.tr("Localizable", "evaluate.journal.entry.placeholder")
        /// Temperature %@ (Feels like %@),  humidity -  %@, pressure - %@, wind speed  - %@, cloud cover - %@
        internal static func weather(_ p1: String, _ p2: String, _ p3: String, _ p4: String, _ p5: String, _ p6: String) -> String {
          return Localizations.tr("Localizable", "evaluate.journal.entry.weather", p1, p2, p3, p4, p5, p6)
        }
        internal enum Photo {
          /// Time
          internal static let date = Localizations.tr("Localizable", "evaluate.journal.entry.photo.date")
          /// Location
          internal static let location = Localizations.tr("Localizable", "evaluate.journal.entry.photo.location")
          /// Use photo %@?
          internal static func question(_ p1: String) -> String {
            return Localizations.tr("Localizable", "evaluate.journal.entry.photo.question", p1)
          }
          /// Use both
          internal static let useBoth = Localizations.tr("Localizable", "evaluate.journal.entry.photo.useBoth")
        }
      }
    }
    internal enum List {
      /// Open list
      internal static let `open` = Localizations.tr("Localizable", "evaluate.list.open")
    }
    internal enum Location {
      /// Unknown place
      internal static let unknown = Localizations.tr("Localizable", "evaluate.location.unknown")
    }
    internal enum Phrase {
      /// What is on your mind? Tap to edit.
      internal static let empty = Localizations.tr("Localizable", "evaluate.phrase.empty")
    }
    internal enum Weather {
      /// Weather data is not available
      internal static let unknown = Localizations.tr("Localizable", "evaluate.weather.unknown")
    }
  }

  internal enum General {
    /// and
    internal static let and = Localizations.tr("Localizable", "general.and")
    /// Archive
    internal static let archive = Localizations.tr("Localizable", "general.archive")
    /// Cancel
    internal static let cancel = Localizations.tr("Localizable", "general.cancel")
    /// Close
    internal static let close = Localizations.tr("Localizable", "general.close")
    /// Created
    internal static let createDate = Localizations.tr("Localizable", "general.createDate")
    /// Delete
    internal static let delete = Localizations.tr("Localizable", "general.delete")
    /// Discard
    internal static let discard = Localizations.tr("Localizable", "general.discard")
    /// Done
    internal static let done = Localizations.tr("Localizable", "general.done")
    /// Edit
    internal static let edit = Localizations.tr("Localizable", "general.edit")
    /// Evaluate Day
    internal static let evaluateday = Localizations.tr("Localizable", "general.evaluateday")
    /// Last 7 days
    internal static let last7 = Localizations.tr("Localizable", "general.last7")
    /// Lifetime
    internal static let lifetime = Localizations.tr("Localizable", "general.lifetime")
    /// Do you like Evaluate Day?
    internal static let like = Localizations.tr("Localizable", "general.like")
    /// More
    internal static let more = Localizations.tr("Localizable", "general.more")
    /// No
    internal static let no = Localizations.tr("Localizable", "general.no")
    /// None
    internal static let `none` = Localizations.tr("Localizable", "general.none")
    /// Ok
    internal static let ok = Localizations.tr("Localizable", "general.ok")
    /// Save
    internal static let save = Localizations.tr("Localizable", "general.save")
    /// Send
    internal static let send = Localizations.tr("Localizable", "general.send")
    /// Skip
    internal static let skip = Localizations.tr("Localizable", "general.skip")
    /// Are you sure?
    internal static let sureQuestion = Localizations.tr("Localizable", "general.sureQuestion")
    /// Today
    internal static let today = Localizations.tr("Localizable", "general.today")
    /// Unarchive
    internal static let unarchive = Localizations.tr("Localizable", "general.unarchive")
    /// Untitled
    internal static let untitled = Localizations.tr("Localizable", "general.untitled")
    /// Version: %@ (%@)
    internal static func version(_ p1: String, _ p2: String) -> String {
      return Localizations.tr("Localizable", "general.version", p1, p2)
    }
    /// Yes
    internal static let yes = Localizations.tr("Localizable", "general.yes")
    internal enum Action {
      /// Open Analytics
      internal static let analytics = Localizations.tr("Localizable", "general.action.analytics")
      /// Evaluate
      internal static let evaluate = Localizations.tr("Localizable", "general.action.evaluate")
    }
    internal enum Notification {
      /// Where have you been? 10 days is a long period of time. You need to fill in the cards as often as you can in order to get a profound analysis. Start right now.
      internal static let _10days = Localizations.tr("Localizable", "general.notification.10days")
      /// The last time the app was launched was 30 days ago. Create a new card or fill in the existing ones. You can also set up additional notifications using the settings menu of the app.
      internal static let _30days = Localizations.tr("Localizable", "general.notification.30days")
      /// How did you spend these 3 days? Don't forget to assess them. It will help you control different areas of your life 😉
      internal static let _3days = Localizations.tr("Localizable", "general.notification.3days")
    }
    internal enum Photo {
      /// Select photo
      internal static let select = Localizations.tr("Localizable", "general.photo.select")
      /// Take photo
      internal static let take = Localizations.tr("Localizable", "general.photo.take")
    }
    internal enum Shortcut {
      internal enum Activity {
        /// Activity
        internal static let title = Localizations.tr("Localizable", "general.shortcut.activity.title")
      }
      internal enum Evaluate {
        /// Evaluate
        internal static let title = Localizations.tr("Localizable", "general.shortcut.evaluate.title")
      }
      internal enum New {
        /// Add new card
        internal static let title = Localizations.tr("Localizable", "general.shortcut.new.title")
      }
    }
  }

  internal enum List {
    /// All your card
    internal static let title = Localizations.tr("Localizable", "list.title")
    internal enum Card {
      /// You can`t evaluate day by this card, you data will be save
      internal static let archiveMessage = Localizations.tr("Localizable", "list.card.archiveMessage")
      /// You can archive card
      internal static let archiveNotDelete = Localizations.tr("Localizable", "list.card.archiveNotDelete")
      /// You can`t UNDO this action
      internal static let deleteMessage = Localizations.tr("Localizable", "list.card.deleteMessage")
      /// You can evaluate days by this card
      internal static let unarchiveMessage = Localizations.tr("Localizable", "list.card.unarchiveMessage")
      internal enum Empty {
        /// Cards help to control, evaluate and analyse your life.
        internal static let description = Localizations.tr("Localizable", "list.card.empty.description")
        /// You haven`t any cards
        internal static let title = Localizations.tr("Localizable", "list.card.empty.title")
      }
      internal enum EmptyType {
        /// Cards help to control, evaluate and analyse your life.
        internal static let subtitle = Localizations.tr("Localizable", "list.card.emptyType.subtitle")
        /// You have not any cards in this type
        internal static let title = Localizations.tr("Localizable", "list.card.emptyType.title")
      }
    }
  }

  internal enum Many {
    /// %li d
    internal static func day(_ p1: Int) -> String {
      return Localizations.tr("Localizable", "many.day", p1)
    }
    /// %li m
    internal static func month(_ p1: Int) -> String {
      return Localizations.tr("Localizable", "many.month", p1)
    }
    /// %li w
    internal static func week(_ p1: Int) -> String {
      return Localizations.tr("Localizable", "many.week", p1)
    }
    /// %li y
    internal static func year(_ p1: Int) -> String {
      return Localizations.tr("Localizable", "many.year", p1)
    }
  }

  internal enum Messages {
    internal enum Data {
      internal enum Cloud {
        internal enum DeleteAll {
          /// Error
          internal static let error = Localizations.tr("Localizable", "messages.data.cloud.deleteAll.error")
          /// Done
          internal static let subtitle = Localizations.tr("Localizable", "messages.data.cloud.deleteAll.subtitle")
          /// All iCloud data deleted
          internal static let title = Localizations.tr("Localizable", "messages.data.cloud.deleteAll.title")
        }
      }
      internal enum Local {
        internal enum DeleteAll {
          /// Done
          internal static let subtitle = Localizations.tr("Localizable", "messages.data.local.deleteAll.subtitle")
          /// All local data deleted
          internal static let title = Localizations.tr("Localizable", "messages.data.local.deleteAll.title")
        }
      }
    }
  }

  internal enum New {
    internal enum Cards {
      /// Add new
      internal static let action = Localizations.tr("Localizable", "new.cards.action")
      internal enum Limit {
        /// You can add only %i cards
        internal static func message(_ p1: Int) -> String {
          return Localizations.tr("Localizable", "new.cards.limit.message", p1)
        }
      }
    }
    internal enum Checkin {
      /// Check in the places that you visit during the day
      internal static let subtitle = Localizations.tr("Localizable", "new.checkin.subtitle")
      /// Check In
      internal static let title = Localizations.tr("Localizable", "new.checkin.title")
    }
    internal enum Color {
      /// Select color of the day
      internal static let subtitle = Localizations.tr("Localizable", "new.color.subtitle")
      /// Color
      internal static let title = Localizations.tr("Localizable", "new.color.title")
    }
    internal enum Controller {
      /// New type of card
      internal static let title = Localizations.tr("Localizable", "new.controller.title")
    }
    internal enum Counter {
      /// Creat for adding or subtracting a single value as you go
      internal static let subtitle = Localizations.tr("Localizable", "new.counter.subtitle")
      /// Counter
      internal static let title = Localizations.tr("Localizable", "new.counter.title")
    }
    internal enum CriterionHundred {
      /// Helps evaluate and analyze various criteria that cannot be tracked with sensors. Evaluation on a 100-point scale.
      internal static let subtitle = Localizations.tr("Localizable", "new.criterionHundred.subtitle")
      /// Criterion (100)
      internal static let title = Localizations.tr("Localizable", "new.criterionHundred.title")
    }
    internal enum CriterionTen {
      /// Helps evaluate and analyze various criteria that cannot be tracked with sensors. Evaluation on a 10-point scale.
      internal static let subtitle = Localizations.tr("Localizable", "new.criterionTen.subtitle")
      /// Criterion (10)
      internal static let title = Localizations.tr("Localizable", "new.criterionTen.title")
    }
    internal enum CriterionThree {
      /// Helps evaluate and analyze various criteria that cannot be tracked with sensors. Evaluation on a 3-point scale.
      internal static let subtitle = Localizations.tr("Localizable", "new.criterionThree.subtitle")
      /// Criterion (3)
      internal static let title = Localizations.tr("Localizable", "new.criterionThree.title")
    }
    internal enum Goal {
      /// Any problem, expressed in numerical form, with the ability to display the progress of achievement
      internal static let subtitle = Localizations.tr("Localizable", "new.goal.subtitle")
      /// Goal
      internal static let title = Localizations.tr("Localizable", "new.goal.title")
    }
    internal enum Habit {
      /// Forming habits through constant monitoring and reminders
      internal static let subtitle = Localizations.tr("Localizable", "new.habit.subtitle")
      /// Habit
      internal static let title = Localizations.tr("Localizable", "new.habit.title")
    }
    internal enum Health {
      /// Track one or more health metrics from Apple Health
      internal static let subtitle = Localizations.tr("Localizable", "new.health.subtitle")
      /// Health
      internal static let title = Localizations.tr("Localizable", "new.health.title")
    }
    internal enum Journal {
      /// A collection of entries that have one theme in common. Entries are supplemented with various auxiliary data (geo-position, weather, entry time and image)
      internal static let subtitle = Localizations.tr("Localizable", "new.journal.subtitle")
      /// Journal
      internal static let title = Localizations.tr("Localizable", "new.journal.title")
    }
    internal enum List {
      /// A list of tasks, things or products that you need to perform, buy or bring. Create a list and complete the tasks in the list.
      internal static let subtitle = Localizations.tr("Localizable", "new.list.subtitle")
      /// List
      internal static let title = Localizations.tr("Localizable", "new.list.title")
    }
    internal enum Phrase {
      /// A short and concise phrase or idea
      internal static let subtitle = Localizations.tr("Localizable", "new.phrase.subtitle")
      /// Phrase
      internal static let title = Localizations.tr("Localizable", "new.phrase.title")
    }
    internal enum Tracker {
      /// It can help you track infrequent mundane activities like medication-taking.
      internal static let subtitle = Localizations.tr("Localizable", "new.tracker.subtitle")
      /// Tracker
      internal static let title = Localizations.tr("Localizable", "new.tracker.title")
    }
  }

  internal enum Permission {
    internal enum Camera {
      /// Capture interesting moments right from the app
      internal static let description = Localizations.tr("Localizable", "permission.camera.description")
      /// Camera
      internal static let title = Localizations.tr("Localizable", "permission.camera.title")
    }
    internal enum Description {
      /// Full functionality of Evaluate Day requires some permissions.
      internal static let subtitle = Localizations.tr("Localizable", "permission.description.subtitle")
      /// Permissions
      internal static let title = Localizations.tr("Localizable", "permission.description.title")
    }
    internal enum Location {
      /// Record where you were, where you made an entry, and get weather data for this time
      internal static let description = Localizations.tr("Localizable", "permission.location.description")
      /// Location
      internal static let title = Localizations.tr("Localizable", "permission.location.title")
    }
    internal enum Notification {
      /// Evaluate Day can send you reminders, and you won't forget to rate your day
      internal static let description = Localizations.tr("Localizable", "permission.notification.description")
      /// Notifications
      internal static let title = Localizations.tr("Localizable", "permission.notification.title")
    }
    internal enum Photos {
      /// Import and save images into the Photos
      internal static let description = Localizations.tr("Localizable", "permission.photos.description")
      /// Photos
      internal static let title = Localizations.tr("Localizable", "permission.photos.title")
    }
  }

  internal enum Settings {
    /// Settings
    internal static let title = Localizations.tr("Localizable", "settings.title")
    internal enum About {
      /// Open Source
      internal static let openSource = Localizations.tr("Localizable", "settings.about.openSource")
      /// Rate in App Store
      internal static let rate = Localizations.tr("Localizable", "settings.about.rate")
      /// Special Thanks
      internal static let specialThanks = Localizations.tr("Localizable", "settings.about.specialThanks")
      /// About
      internal static let title = Localizations.tr("Localizable", "settings.about.title")
      /// View welcome screens
      internal static let welcome = Localizations.tr("Localizable", "settings.about.welcome")
      internal enum Legal {
        /// Weather Powered by Dark Sky
        internal static let forecast = Localizations.tr("Localizable", "settings.about.legal.forecast")
        /// Legal
        internal static let title = Localizations.tr("Localizable", "settings.about.legal.title")
      }
      internal enum Share {
        /// Try this awesome app 😉
        internal static let message = Localizations.tr("Localizable", "settings.about.share.message")
        /// Share Evaluate Day with friends
        internal static let title = Localizations.tr("Localizable", "settings.about.share.title")
      }
    }
    internal enum General {
      /// Celsius
      internal static let celsius = Localizations.tr("Localizable", "settings.general.celsius")
      /// Save to Camera Roll
      internal static let photos = Localizations.tr("Localizable", "settings.general.photos")
      /// Sound Effects
      internal static let sounds = Localizations.tr("Localizable", "settings.general.sounds")
      /// General
      internal static let title = Localizations.tr("Localizable", "settings.general.title")
      /// Week start
      internal static let week = Localizations.tr("Localizable", "settings.general.week")
    }
    internal enum Notifications {
      /// Add notification
      internal static let add = Localizations.tr("Localizable", "settings.notifications.add")
      /// Notifications
      internal static let title = Localizations.tr("Localizable", "settings.notifications.title")
      internal enum New {
        /// Card
        internal static let card = Localizations.tr("Localizable", "settings.notifications.new.card")
        /// Did you have a nice day? Evaluate...
        internal static let defaultMessage = Localizations.tr("Localizable", "settings.notifications.new.defaultMessage")
        /// Message
        internal static let message = Localizations.tr("Localizable", "settings.notifications.new.message")
        /// Optional
        internal static let `optional` = Localizations.tr("Localizable", "settings.notifications.new.optional")
        /// Select card
        internal static let selectCard = Localizations.tr("Localizable", "settings.notifications.new.selectCard")
        /// Time
        internal static let time = Localizations.tr("Localizable", "settings.notifications.new.time")
        /// Notification
        internal static let title = Localizations.tr("Localizable", "settings.notifications.new.title")
        internal enum Repeat {
          /// Daily
          internal static let daily = Localizations.tr("Localizable", "settings.notifications.new.repeat.daily")
          /// Repeat
          internal static let title = Localizations.tr("Localizable", "settings.notifications.new.repeat.title")
          /// Weekdays
          internal static let weekdays = Localizations.tr("Localizable", "settings.notifications.new.repeat.weekdays")
        }
      }
    }
    internal enum Passcode {
      /// Change passcode
      internal static let change = Localizations.tr("Localizable", "settings.passcode.change")
      /// Re-enter new passcode
      internal static let reenter = Localizations.tr("Localizable", "settings.passcode.reenter")
      /// Require after...
      internal static let require = Localizations.tr("Localizable", "settings.passcode.require")
      /// Passcode
      internal static let title = Localizations.tr("Localizable", "settings.passcode.title")
      /// Unlock %@
      internal static func unlock(_ p1: String) -> String {
        return Localizations.tr("Localizable", "settings.passcode.unlock", p1)
      }
      internal enum Delay {
        /// After 1 hour
        internal static let _1h = Localizations.tr("Localizable", "settings.passcode.delay.1h")
        /// After 1 minute
        internal static let _1m = Localizations.tr("Localizable", "settings.passcode.delay.1m")
        /// Immediately
        internal static let immediately = Localizations.tr("Localizable", "settings.passcode.delay.immediately")
        /// After %@ minutes
        internal static func minutes(_ p1: String) -> String {
          return Localizations.tr("Localizable", "settings.passcode.delay.minutes", p1)
        }
      }
      internal enum Enter {
        /// Enter new passcode
        internal static let new = Localizations.tr("Localizable", "settings.passcode.enter.new")
        /// Enter passcode
        internal static let old = Localizations.tr("Localizable", "settings.passcode.enter.old")
      }
      internal enum FaceID {
        /// Prompt for Face ID
        internal static let prompt = Localizations.tr("Localizable", "settings.passcode.faceID.prompt")
        /// Face ID
        internal static let title = Localizations.tr("Localizable", "settings.passcode.faceID.title")
      }
      internal enum TouchID {
        /// Prompt for Touch ID
        internal static let prompt = Localizations.tr("Localizable", "settings.passcode.touchID.prompt")
        /// Touch ID
        internal static let title = Localizations.tr("Localizable", "settings.passcode.touchID.title")
      }
    }
    internal enum Pro {
      /// Any Questions? Contact Us!
      internal static let questions = Localizations.tr("Localizable", "settings.pro.questions")
      /// Restore Purchases
      internal static let restore = Localizations.tr("Localizable", "settings.pro.restore")
      /// Subscription
      internal static let title = Localizations.tr("Localizable", "settings.pro.title")
      internal enum Description {
        /// Some cool and useful features are unavaible without an active subscription.
        internal static let mainTitle = Localizations.tr("Localizable", "settings.pro.description.mainTitle")
        /// Upgade to Evaluate Day Pro gain access to some extra features: Cloud Sync, Unlimited Cards, Advanced Analytics, Data Export, and much more...
        internal static let title = Localizations.tr("Localizable", "settings.pro.description.title")
        internal enum More {
          /// And much more...
          internal static let title = Localizations.tr("Localizable", "settings.pro.description.more.title")
          internal enum Activity {
            /// Full analytics on the use of the application. View all photos added to the app in one place.
            internal static let description = Localizations.tr("Localizable", "settings.pro.description.more.activity.description")
            /// Full activity
            internal static let title = Localizations.tr("Localizable", "settings.pro.description.more.activity.title")
          }
          internal enum Analytics {
            /// Complete analytics for each card. Everything you need in one place
            internal static let description = Localizations.tr("Localizable", "settings.pro.description.more.analytics.description")
            /// Analytics
            internal static let title = Localizations.tr("Localizable", "settings.pro.description.more.analytics.title")
          }
          internal enum Cards {
            /// Add the necessary number of cards to the application, track or write down everything you need.
            internal static let description = Localizations.tr("Localizable", "settings.pro.description.more.cards.description")
            /// Unlimited cards
            internal static let title = Localizations.tr("Localizable", "settings.pro.description.more.cards.title")
          }
          internal enum Export {
            /// Export card data to the format you need (csv, json or txt)
            internal static let description = Localizations.tr("Localizable", "settings.pro.description.more.export.description")
            /// Export
            internal static let title = Localizations.tr("Localizable", "settings.pro.description.more.export.title")
          }
          internal enum Future {
            /// Evaluate Day is constantly evolving. We are adding new cards and new functionality.
            internal static let description = Localizations.tr("Localizable", "settings.pro.description.more.future.description")
            /// Future
            internal static let title = Localizations.tr("Localizable", "settings.pro.description.more.future.title")
          }
          internal enum Passcode {
            /// Protecting the application with a passcode will help keep your data safe.
            internal static let description = Localizations.tr("Localizable", "settings.pro.description.more.passcode.description")
            /// Passcode
            internal static let title = Localizations.tr("Localizable", "settings.pro.description.more.passcode.title")
          }
          internal enum Past {
            /// Rate missed days for up to 3 days back
            internal static let description = Localizations.tr("Localizable", "settings.pro.description.more.past.description")
            /// Past
            internal static let title = Localizations.tr("Localizable", "settings.pro.description.more.past.title")
          }
          internal enum Sync {
            /// Synchronize data with all your iOS devices
            internal static let description = Localizations.tr("Localizable", "settings.pro.description.more.sync.description")
            /// Sync
            internal static let title = Localizations.tr("Localizable", "settings.pro.description.more.sync.title")
          }
          internal enum Themes {
            /// Customize Evaluate Day the way you like it. To do this, use one of the themes of the application
            internal static let description = Localizations.tr("Localizable", "settings.pro.description.more.themes.description")
            /// Themes
            internal static let title = Localizations.tr("Localizable", "settings.pro.description.more.themes.title")
          }
        }
      }
      internal enum Node {
        /// Unlimeted card, advanced analytics, export, sync and more!
        internal static let subtitle = Localizations.tr("Localizable", "settings.pro.node.subtitle")
        /// Unlock Evaluate Day Pro
        internal static let title = Localizations.tr("Localizable", "settings.pro.node.title")
        internal enum Ispro {
          /// Thank you for your support!
          internal static let subtitle = Localizations.tr("Localizable", "settings.pro.node.ispro.subtitle")
          /// Evaluate Day Pro Unlocked
          internal static let title = Localizations.tr("Localizable", "settings.pro.node.ispro.title")
        }
      }
      internal enum Privacy {
        /// Please review:
        internal static let description = Localizations.tr("Localizable", "settings.pro.privacy.description")
        /// Terms of service
        internal static let eula = Localizations.tr("Localizable", "settings.pro.privacy.eula")
        /// Privacy Policy
        internal static let privacy = Localizations.tr("Localizable", "settings.pro.privacy.privacy")
      }
      internal enum Review {
        /// Thank you for your support!
        internal static let subtitle = Localizations.tr("Localizable", "settings.pro.review.subtitle")
        /// you are a Pro
        internal static let title = Localizations.tr("Localizable", "settings.pro.review.title")
        internal enum Subscription {
          /// The date refers to the next renewal of the subscription. The free trial is counting as a one time subscription period and will be renewed as a paid subscription automatically.
          internal static let description = Localizations.tr("Localizable", "settings.pro.review.subscription.description")
          /// Valid until %@
          internal static func subtitle(_ p1: String) -> String {
            return Localizations.tr("Localizable", "settings.pro.review.subscription.subtitle", p1)
          }
          /// Subscription
          internal static let title = Localizations.tr("Localizable", "settings.pro.review.subscription.title")
        }
      }
      internal enum Subscription {
        /// Manage Subscription
        internal static let manage = Localizations.tr("Localizable", "settings.pro.subscription.manage")
        internal enum Buy {
          /// %@ / Year
          internal static func annualy(_ p1: String) -> String {
            return Localizations.tr("Localizable", "settings.pro.subscription.buy.annualy", p1)
          }
          /// %@ / Month
          internal static func monthly(_ p1: String) -> String {
            return Localizations.tr("Localizable", "settings.pro.subscription.buy.monthly", p1)
          }
        }
        internal enum Description {
          /// All subscription can be canceled at any time.
          internal static let cancel = Localizations.tr("Localizable", "settings.pro.subscription.description.cancel")
          /// Subscriptions will be charged to your credit card through your iTunes account. Your subscription will automatically renew unless canceled at least 24 hours before the end of the current period. You will not be able to cancel the subscription once activated. Manage your subscriptions in Account Settings after purchase. Any unused portion of a free trial peri​od, will be forfeited when the user purchases a subscription.
          internal static let iTunes = Localizations.tr("Localizable", "settings.pro.subscription.description.iTunes")
        }
        internal enum Introductory {
          /// %@ discount
          internal static func discount(_ p1: String) -> String {
            return Localizations.tr("Localizable", "settings.pro.subscription.introductory.discount", p1)
          }
          /// Try %@ per %@
          internal static func start(_ p1: String, _ p2: String) -> String {
            return Localizations.tr("Localizable", "settings.pro.subscription.introductory.start", p1, p2)
          }
          /// Trial Available, try %@ for free
          internal static func trial(_ p1: String) -> String {
            return Localizations.tr("Localizable", "settings.pro.subscription.introductory.trial", p1)
          }
        }
        internal enum Title {
          /// 12 Month
          internal static let anuualy = Localizations.tr("Localizable", "settings.pro.subscription.title.anuualy")
          /// Continue
          internal static let `continue` = Localizations.tr("Localizable", "settings.pro.subscription.title.continue")
          /// One Time Purchase - %@
          internal static func lifetime(_ p1: String) -> String {
            return Localizations.tr("Localizable", "settings.pro.subscription.title.lifetime", p1)
          }
          /// 1 Month
          internal static let monthly = Localizations.tr("Localizable", "settings.pro.subscription.title.monthly")
        }
      }
      internal enum View {
        /// Read More ...
        internal static let readMore = Localizations.tr("Localizable", "settings.pro.view.readMore")
        /// Unlock
        internal static let unlock = Localizations.tr("Localizable", "settings.pro.view.unlock")
      }
    }
    internal enum Support {
      /// FAQ
      internal static let faq = Localizations.tr("Localizable", "settings.support.faq")
      /// Support
      internal static let title = Localizations.tr("Localizable", "settings.support.title")
      internal enum Mail {
        /// Evaluate Day Version: %@ \n Evaluate Day Build: %@ \n iOS Version: %@
        internal static func body(_ p1: String, _ p2: String, _ p3: String) -> String {
          return Localizations.tr("Localizable", "settings.support.mail.body", p1, p2, p3)
        }
        /// Evaluate Day Feedback
        internal static let subject = Localizations.tr("Localizable", "settings.support.mail.subject")
      }
      internal enum MailError {
        /// This device is not configured to send mail.
        internal static let message = Localizations.tr("Localizable", "settings.support.mailError.message")
        /// Mail Error
        internal static let title = Localizations.tr("Localizable", "settings.support.mailError.title")
      }
    }
    internal enum Sync {
      /// Evaluate Day Sync
      internal static let evaluatedaysync = Localizations.tr("Localizable", "settings.sync.evaluatedaysync")
      /// Last Sync
      internal static let last = Localizations.tr("Localizable", "settings.sync.last")
      /// never
      internal static let never = Localizations.tr("Localizable", "settings.sync.never")
      /// Sync
      internal static let title = Localizations.tr("Localizable", "settings.sync.title")
      internal enum Data {
        /// Data
        internal static let title = Localizations.tr("Localizable", "settings.sync.data.title")
        internal enum Cloud {
          /// Delete data from iCloud
          internal static let delete = Localizations.tr("Localizable", "settings.sync.data.cloud.delete")
          /// All data from iCloud will be deleted. This will delete data from all synchronized devices. The data stored at this device will remain intact. 
          internal static let deleteDescription = Localizations.tr("Localizable", "settings.sync.data.cloud.deleteDescription")
          /// Enable iCloud Sync
          internal static let enable = Localizations.tr("Localizable", "settings.sync.data.cloud.enable")
          /// iCloud
          internal static let header = Localizations.tr("Localizable", "settings.sync.data.cloud.header")
        }
        internal enum Export {
          /// Export all data
          internal static let export = Localizations.tr("Localizable", "settings.sync.data.export.export")
          /// Export
          internal static let header = Localizations.tr("Localizable", "settings.sync.data.export.header")
        }
        internal enum Local {
          /// Delete all local data
          internal static let delete = Localizations.tr("Localizable", "settings.sync.data.local.delete")
          /// All local data will be deleted. This will also delete data from all devices. If you would like to remove data from this device only, please turn off the synchronization first.
          internal static let deleteDescription = Localizations.tr("Localizable", "settings.sync.data.local.deleteDescription")
          /// Local Data
          internal static let header = Localizations.tr("Localizable", "settings.sync.data.local.header")
        }
      }
    }
    internal enum Themes {
      /// Change App Icon
      internal static let iconChange = Localizations.tr("Localizable", "settings.themes.iconChange")
      /// Appearance
      internal static let title = Localizations.tr("Localizable", "settings.themes.title")
      internal enum Select {
        /// Select a Icon
        internal static let icon = Localizations.tr("Localizable", "settings.themes.select.icon")
        /// Select a Theme
        internal static let theme = Localizations.tr("Localizable", "settings.themes.select.theme")
      }
    }
  }

  internal enum Share {
    /// Shared with Evaluate Day app
    internal static let description = Localizations.tr("Localizable", "share.description")
    internal enum Link {
      /// Try Evaluate Day
      internal static let title = Localizations.tr("Localizable", "share.link.title")
    }
  }

  internal enum Tabbar {
    /// Activity
    internal static let activity = Localizations.tr("Localizable", "tabbar.activity")
    /// Cards
    internal static let cards = Localizations.tr("Localizable", "tabbar.cards")
    /// Evaluate Day
    internal static let evaluate = Localizations.tr("Localizable", "tabbar.evaluate")
    /// Settings
    internal static let settings = Localizations.tr("Localizable", "tabbar.settings")
  }

  internal enum Update {
    /// Download now
    internal static let button = Localizations.tr("Localizable", "update.button")
    /// In new version we add new type of cards, please download new version from App Store
    internal static let subtitle = Localizations.tr("Localizable", "update.subtitle")
    /// Please update your version of Evaluate Day
    internal static let title = Localizations.tr("Localizable", "update.title")
  }

  internal enum Welcome {
    /// Yes, sure
    internal static let next = Localizations.tr("Localizable", "welcome.next")
    /// Welcome
    internal static let title = Localizations.tr("Localizable", "welcome.title")
    internal enum New {
      internal enum All {
        /// Enjoy!
        internal static let enjoy = Localizations.tr("Localizable", "welcome.new.all.enjoy")
        /// That's all
        internal static let firstMessage = Localizations.tr("Localizable", "welcome.new.all.firstMessage")
        /// Please enjoy the app. And will write us your feedback
        internal static let secondMessage = Localizations.tr("Localizable", "welcome.new.all.secondMessage")
      }
      internal enum Cards {
        /// Evaluate Collection
        internal static let collection = Localizations.tr("Localizable", "welcome.new.cards.collection")
        /// Что бы вам проще было начать, мы можем создать для вас набор карточек
        internal static let fifthdMessage = Localizations.tr("Localizable", "welcome.new.cards.fifthdMessage")
        /// Основное понятие приложения это карточки. Выберите, то что, хотите оценить и создайте подходящую карточку.
        internal static let firstMessage = Localizations.tr("Localizable", "welcome.new.cards.firstMessage")
        /// Карточки можно объединять в коллекции, так вы смодете оценивать то, что захотите по множеству критерий
        internal static let fourthMessage = Localizations.tr("Localizable", "welcome.new.cards.fourthMessage")
        /// Yes, sure
        internal static let one = Localizations.tr("Localizable", "welcome.new.cards.one")
        /// Все что останеться потом, это день за днем оценивать данные в этой карточки.
        internal static let secondMessage = Localizations.tr("Localizable", "welcome.new.cards.secondMessage")
        /// Do it for you?
        internal static let seventhdMessage = Localizations.tr("Localizable", "welcome.new.cards.seventhdMessage")
        /// Естесвенно вы сможете позже их изменить
        internal static let sixthdMessage = Localizations.tr("Localizable", "welcome.new.cards.sixthdMessage")
        /// Через какое то время, сложиться объяктивная картина, по которой можно будет делать выводы
        internal static let thirdMessage = Localizations.tr("Localizable", "welcome.new.cards.thirdMessage")
        /// Not needed
        internal static let two = Localizations.tr("Localizable", "welcome.new.cards.two")
      }
      internal enum Email {
        /// I will do it later
        internal static let empty = Localizations.tr("Localizable", "welcome.new.email.empty")
        /// Отлично осталось совсем не много
        internal static let firstMessage = Localizations.tr("Localizable", "welcome.new.email.firstMessage")
        /// email
        internal static let placeholder = Localizations.tr("Localizable", "welcome.new.email.placeholder")
        /// Evaluate Day постоянно развивается, подпишитесь на нашу рассылку, что бы быть в курсе последних идей и новостей
        internal static let secondMessage = Localizations.tr("Localizable", "welcome.new.email.secondMessage")
        /// Обещаем писать не чаще 2 раз в месяц и не какого спама
        internal static let thirdMessage = Localizations.tr("Localizable", "welcome.new.email.thirdMessage")
      }
      internal enum Intro {
        /// Welcome on board, we so glad to see you in Evaluate Day app. \nChipp Studio Team
        internal static let firstMessage = Localizations.tr("Localizable", "welcome.new.intro.firstMessage")
        /// It is the quick onboarding, we need to know more about you. To make your experience with app better.
        internal static let secondMessage = Localizations.tr("Localizable", "welcome.new.intro.secondMessage")
        /// Are you ready to start?
        internal static let thirdMessage = Localizations.tr("Localizable", "welcome.new.intro.thirdMessage")
      }
      internal enum Pro {
        /// Nice app, I am in
        internal static let buyed = Localizations.tr("Localizable", "welcome.new.pro.buyed")
        /// One more thing
        internal static let firstMessage = Localizations.tr("Localizable", "welcome.new.pro.firstMessage")
        /// I will do it later
        internal static let notBuyed = Localizations.tr("Localizable", "welcome.new.pro.notBuyed")
        /// Воспользуйтесь всеми функциями Evaluate Day без ограничений
        internal static let secondMessage = Localizations.tr("Localizable", "welcome.new.pro.secondMessage")
      }
      internal enum User {
        /// I prefer stay incognito
        internal static let emptyName = Localizations.tr("Localizable", "welcome.new.user.emptyName")
        /// Greate, let's start
        internal static let firstMessage = Localizations.tr("Localizable", "welcome.new.user.firstMessage")
        /// Name
        internal static let placeholder = Localizations.tr("Localizable", "welcome.new.user.placeholder")
        /// What is your name?
        internal static let secondMessage = Localizations.tr("Localizable", "welcome.new.user.secondMessage")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension Localizations {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
