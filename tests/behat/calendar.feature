@mod @mod_scheduler
Feature: Scheduler entries in calendar
  In order to use scheduler properly
  As a teacher and student
  I need to see scheduler entries in calendar.

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email                |
      | teacher1 | Teacher   | 1        | teacher1@example.com |
      | student1 | Student   | 1        | student1@example.com |
      | student2 | Student   | 2        | student2@example.com |
    And the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1        | 0        |
      | Course 2 | C2        | 0        |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher1 | C1     | editingteacher |
      | student1 | C1     | student        |
      | student2 | C1     | student        |
      | teacher1 | C2     | editingteacher |
      | student1 | C2     | student        |
      | student2 | C2     | student        |
    And the following "activities" exist:
      | activity  | name             | intro   | course | idnumber   | groupmode | schedulermode | maxbookings |
      | scheduler | Test scheduler 1 | Intro 1 | C1     | scheduler1 | 0         | oneonly       | 1           |
      | scheduler | Test scheduler 2 | Intro 2 | C2     | scheduler2 | 0         | oneonly       | 1           |
    And the following "blocks" exist:
      | blockname         | contextlevel | reference | pagetypepattern | defaultregion |
      | calendar_upcoming | Course       | C1        | course-view-*   | side-pre      |
      | calendar_upcoming | Course       | C2        | course-view-*   | side-pre      |

  Scenario: The entries of a scheduler are shown in the calendar block of the affected course only
    Given the following "mod_scheduler > slots" exist:
      | scheduler  | starttime            | duration | teacher  | location  |
      | scheduler2 | ##tomorrow 10:00am## | 15       | teacher1 | My office |
    When I am on the "Course 1" "course" page logged in as "teacher1"
    And I turn editing mode on
    And I click on "Add a block" "link"
    And I am on the "scheduler2" Activity page logged in as "student1"
    And I should see "10:00 AM" in the "slotbookertable" "table"
    And I click on "Book slot" "button" in the "10:00 AM" "table_row"
    When I am on the "Course 1" "course" page logged in as "teacher1"
    Then I should not see "Meeting with your Student," in the "Upcoming events" "block"
    And I am on the "Course 2" "course" page logged in as "teacher1"
    And I should see "Meeting with your Student," in the "Upcoming events" "block"
    But I should not see "Meeting with your Teacher," in the "Upcoming events" "block"
    And I am on the "Course 1" "course" page logged in as "student1"
    And I should not see "Meeting with your Teacher," in the "Upcoming events" "block"
    And I am on the "Course 2" "course" page logged in as "student1"
    And I should see "Meeting with your Teacher," in the "Upcoming events" "block"
    But I should not see "Meeting with your Student," in the "Upcoming events" "block"
    And I am on the "Course 2" "course" page logged in as "student2"
    And I should not see "Meeting with your Teacher," in the "Upcoming events" "block"
