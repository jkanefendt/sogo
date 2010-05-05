/*
  Copyright (C) 2000-2005 SKYRIX Software AG

  This file is part of SOPE.

  SOPE is free software; you can redistribute it and/or modify it under
  the terms of the GNU Lesser General Public License as published by the
  Free Software Foundation; either version 2, or (at your option) any
  later version.

  SOPE is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
  License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with SOPE; see the file COPYING.  If not, write to the
  Free Software Foundation, 59 Temple Place - Suite 330, Boston, MA
  02111-1307, USA.
*/

#import <Foundation/NSArray.h>
#import <Foundation/NSString.h>
#import <Foundation/NSURL.h>
#import <Foundation/NSValue.h>

#import "NSCalendarDate+NGCards.h"

#import "iCalAlarm.h"
#import "iCalDateTime.h"
#import "iCalEntityObject.h"
#import "iCalPerson.h"

@interface iCalEntityObject (PrivateAPI)
- (NSArray *)_filteredAttendeesThinkingOfPersons:(BOOL)_persons;
@end

@implementation iCalEntityObject

- (Class) classForTag: (NSString *) classTag
{
  Class tagClass;

  if ([classTag isEqualToString: @"ATTENDEE"]
      || [classTag isEqualToString: @"ORGANIZER"])
    tagClass = [iCalPerson class];
  else if ([classTag isEqualToString: @"VALARM"])
    tagClass = [iCalAlarm class];
  else if ([classTag isEqualToString: @"SUMMARY"]
           || [classTag isEqualToString: @"UID"]
           || [classTag isEqualToString: @"COMMENT"]
           || [classTag isEqualToString: @"DESCRIPTION"]
           || [classTag isEqualToString: @"CLASS"]
           || [classTag isEqualToString: @"STATUS"]
           || [classTag isEqualToString: @"SEQUENCE"]
           || [classTag isEqualToString: @"URL"]
           || [classTag isEqualToString: @"PRIORITY"]
           || [classTag isEqualToString: @"CATEGORIES"]
           || [classTag isEqualToString: @"LOCATION"])
    tagClass = [CardElement class];
  else if ([classTag isEqualToString: @"DTSTAMP"]
           || [classTag isEqualToString: @"DTSTART"]
           || [classTag isEqualToString: @"RECURRENCE-ID"]
           || [classTag isEqualToString: @"CREATED"]
           || [classTag isEqualToString: @"LAST-MODIFIED"])
    tagClass = [iCalDateTime class];
  else
    tagClass = [super classForTag: classTag];

  return tagClass;
}

/* accessors */

- (void) setUid: (NSString *) _uid
{
  [[self uniqueChildWithTag: @"uid"] setValue: 0 to: _uid];
}

- (NSString *) uid
{
  return [[self uniqueChildWithTag: @"uid"] value: 0];
}

- (void) setSummary: (NSString *) _value
{
  [[self uniqueChildWithTag: @"summary"] setValue: 0 to: _value];
}

- (NSString *) summary
{
  return [[self uniqueChildWithTag: @"summary"] value: 0];
}

- (void) setLocation: (NSString *) _value
{
  [[self uniqueChildWithTag: @"location"] setValue: 0 to: _value];
}

- (NSString *) location
{
  return [[self uniqueChildWithTag: @"location"] value: 0];
}

- (void) setComment: (NSString *) _value
{
  [[self uniqueChildWithTag: @"description"] setValue: 0 to: _value];
}

- (NSString *) comment
{
  return [[self uniqueChildWithTag: @"description"] value: 0];
}

- (void) setAccessClass: (NSString *) _value
{
  [[self uniqueChildWithTag: @"class"] setValue: 0 to: _value];
}

- (NSString *) accessClass
{
  return [[self uniqueChildWithTag: @"class"] value: 0];
}

- (iCalAccessClass) symbolicAccessClass
{
  iCalAccessClass symbolicAccessClass;
  NSString *accessClass;

  accessClass = [[self accessClass] uppercaseString];
  if ([accessClass isEqualToString: @"PRIVATE"])
    symbolicAccessClass = iCalAccessPrivate;
  else if ([accessClass isEqualToString: @"CONFIDENTIAL"])
    symbolicAccessClass = iCalAccessConfidential;
  else
    symbolicAccessClass = iCalAccessPublic;

  return symbolicAccessClass;
}

- (BOOL) isPublic
{
  return ([self symbolicAccessClass] == iCalAccessPublic);
}

- (void) setPriority: (NSString *) _value
{
  [[self uniqueChildWithTag: @"priority"] setValue: 0 to: _value];
}

- (NSString *) priority
{
  return [[self uniqueChildWithTag: @"priority"] value: 0];
}

- (void) setCategories: (NSString *) _value
{
  [[self uniqueChildWithTag: @"categories"] setValue: 0 to: _value];
}

- (NSString *) categories
{
  return [[self uniqueChildWithTag: @"categories"] value: 0];
}

- (void) setUserComment: (NSString *) _value
{
  [[self uniqueChildWithTag: @"usercomment"] setValue: 0 to: _value];
}

- (NSString *) userComment
{
  return [[self uniqueChildWithTag: @"usercomment"] value: 0];
}

- (void) setStatus: (NSString *) _value
{
  [[self uniqueChildWithTag: @"status"] setValue: 0 to: _value];
}

- (NSString *) status
{
  return [[self uniqueChildWithTag: @"status"] value: 0];
}

- (void) setSequence: (NSNumber *)_value
{
  NSString *sequence;

  sequence = [NSString stringWithFormat: @"%@", _value];
  [[self uniqueChildWithTag: @"sequence"] setValue: 0
                                          to: sequence];;
}

- (NSNumber *) sequence
{
  NSString *sequence;

  sequence = [[self uniqueChildWithTag: @"sequence"] value: 0];

  return [NSNumber numberWithInt: [sequence intValue]];
}

- (void) increaseSequence
{
  int seq;
  
  seq = [[self sequence] intValue];
  seq += 1;
  [self setSequence: [NSNumber numberWithInt: seq]];
}

- (void) setCreated: (NSCalendarDate *) newCreated
{
  [(iCalDateTime *) [self uniqueChildWithTag: @"created"]
		    setDateTime: newCreated];
}

- (NSCalendarDate *) created
{
  return [(iCalDateTime *) [self uniqueChildWithTag: @"created"]
			   dateTime];
}

- (void) setLastModified: (NSCalendarDate *) newLastModified
{
  [(iCalDateTime *) [self uniqueChildWithTag: @"last-modified"]
		    setDateTime: newLastModified];
}

- (NSCalendarDate *) lastModified
{
  return [(iCalDateTime *) [self uniqueChildWithTag: @"last-modified"]
			   dateTime];
}

- (void) setTimeStampAsDate: (NSCalendarDate *) newTimeStamp
{
  [(iCalDateTime *) [self uniqueChildWithTag: @"dtstamp"]
		    setDateTime: newTimeStamp];
}

- (NSCalendarDate *) timeStampAsDate
{
  return [(iCalDateTime *) [self uniqueChildWithTag: @"dtstamp"]
			   dateTime];
}

- (void) setStartDate: (NSCalendarDate *) newStartDate
{
  [(iCalDateTime *) [self uniqueChildWithTag: @"dtstart"]
		    setDateTime: newStartDate];
}

- (NSCalendarDate *) startDate
{
  return [(iCalDateTime *) [self uniqueChildWithTag: @"dtstart"]
			   dateTime];
}

- (void) setRecurrenceId: (NSCalendarDate *) newRecId
{
  [(iCalDateTime *) [self uniqueChildWithTag: @"recurrence-id"]
		    setDateTime: newRecId];
}

- (NSCalendarDate *) recurrenceId
{
  return [(iCalDateTime *) [self uniqueChildWithTag: @"recurrence-id"]
			   dateTime];
}

- (BOOL) hasStartDate
{
  return ([[self childrenWithTag: @"dtstart"] count] > 0);
}

- (void) setOrganizer: (iCalPerson *) _organizer
{
  if (_organizer)
    {
      [_organizer setTag: @"organizer"];
      [self setUniqueChild: _organizer];
    }
  else
    [children removeObjectsInArray: [self childrenWithTag: @"organizer"]];
}

- (iCalPerson *) organizer
{
  return (iCalPerson *) [self uniqueChildWithTag: @"organizer"];
}

- (void) removeAllAttendees
{
  [children removeObjectsInArray: [self attendees]];
}

- (void) addToAttendees: (iCalPerson *) _person
{
  [_person setTag: @"attendee"];
  [self addChild: _person];
}

- (void) removeFromAttendees: (iCalPerson *) oldAttendee
{
  NSMutableArray *newAttendees;
  int count, max;

  newAttendees = [NSMutableArray arrayWithArray: [self attendees]];
  max = [newAttendees count];
  for (count = max - 1; count > -1; count--)
    {
      if ([[newAttendees objectAtIndex: count]
            hasSameEmailAddress: oldAttendee])
        [newAttendees removeObjectAtIndex: count];
    }

  [self setAttendees: newAttendees];
}

- (void) setAttendees: (NSArray *) attendees
{
  [self removeAllAttendees];
  [self addChildren: attendees];
}

- (NSArray *) attendees
{
  return [self childrenWithTag: @"attendee"];
}

- (BOOL) isAttendee: (id) _email
{
  NSArray *attEmails;
  
  _email     = [_email lowercaseString];
  attEmails = [[self attendees] valueForKey:@"rfc822Email"];
  attEmails = [attEmails valueForKey: @"lowercaseString"];
  return [attEmails containsObject:_email];
}

- (iCalPerson *) findAttendeeWithEmail: (id) email
{
  NSArray *attendees;
  unsigned int count, max;
  NSString *lowerEmail, *currentEmail;
  iCalPerson *attendee, *currentAttendee;

  attendee = nil;

  lowerEmail = [email lowercaseString];
  attendees = [self attendees];
  max = [attendees count];

  for (count = 0; attendee == nil && count < max; count++)
    {
      currentAttendee = [attendees objectAtIndex: count];
      currentEmail = [[currentAttendee rfc822Email] lowercaseString];
      if ([currentEmail isEqualToString: lowerEmail])
        attendee = currentAttendee;
    }

  return attendee;
}

- (void) removeAllAlarms
{
  [children removeObjectsInArray: [self alarms]];
}

- (void) addToAlarms: (id) _alarm
{
  if (_alarm)
    {
      [_alarm setTag: @"valarm"];
      [self addChild: _alarm];
    }
}

- (BOOL) hasAlarms
{
  return ([[self childrenWithTag: @"valarm"] count] > 0);
}

- (NSArray *) alarms
{
  return [self childrenWithTag: @"valarm"];
}

- (void) setAttach: (id) _value
{
  NSString *asString;

  if ([_value isKindOfClass: [NSString class]])
    asString = _value;
  else if ([_value isKindOfClass: [NSURL class]])
    asString = [_value absoluteString];
  else
    asString = @"";

  [[self uniqueChildWithTag: @"attach"] setValue: 0 to: asString];
}

- (NSURL *) attach
{
  NSString *stringAttach;
  NSURL *url;

  stringAttach = [[self uniqueChildWithTag: @"attach"] value: 0];
  url = [NSURL URLWithString: stringAttach];

  if (!url && [stringAttach length] > 0)
    url = [NSURL URLWithString: [NSString stringWithFormat: @"http://%@", stringAttach]];
  
  return url;
}

- (void) setUrl: (id) _value
{
  NSString *asString;

  if ([_value isKindOfClass: [NSString class]])
    asString = _value;
  else if ([_value isKindOfClass: [NSURL class]])
    asString = [_value absoluteString];
  else
    asString = @"";

  [[self uniqueChildWithTag: @"url"] setValue: 0 to: asString];
}

- (NSURL *) url
{
  NSString *stringUrl;

  stringUrl = [[self uniqueChildWithTag: @"url"] value: 0];

  return [NSURL URLWithString: stringUrl];
}

/* stuff */
- (BOOL) isOrganizer: (id) _email
{
  NSString *organizerMail;

  organizerMail = [[self organizer] rfc822Email];

  return [[organizerMail lowercaseString]
           isEqualToString: [_email lowercaseString]];
}

- (NSArray *) participants
{
  NSArray *list;
  NSMutableArray *filtered;
  unsigned count, max;
  iCalPerson *person;
  NSString *role;

  list = [self attendees];
  max = [list count];
  filtered = [NSMutableArray arrayWithCapacity: max];
  for (count = 0; count < max; count++)
    {
      person = [list objectAtIndex: count];
      role = [[person role] uppercaseString];
      if (![role hasPrefix: @"NON-PARTICIPANT"])
        [filtered addObject: person];
    }

  return filtered; 
}

- (NSArray *) nonParticipants
{
  return [self childrenWithTag: @"attendee"
                  andAttribute: @"role"
                   havingValue: @"non-participant"];
}

- (BOOL) isParticipant: (id) _email
{
  NSArray *partEmails;
  
  _email     = [_email lowercaseString];
  partEmails = [[self participants] valueForKey:@"rfc822Email"];
  partEmails = [partEmails valueForKey: @"lowercaseString"];
  return [partEmails containsObject:_email];
}

- (NSComparisonResult) _compareValue: (id) selfValue
			   withValue: (id) otherValue
{
  NSComparisonResult result;

  if (selfValue)
    {
      if (otherValue)
	result = [selfValue compare: otherValue];
      else
	result = NSOrderedDescending;
    }
  else
    {
      if (otherValue)
	result = NSOrderedAscending;
      else
	result = NSOrderedSame;
    }

  return result;
}

- (NSComparisonResult) _compareVersions: (iCalEntityObject *) otherObject
{
  NSComparisonResult result;

  result = [self _compareValue: [self sequence]
		 withValue: [otherObject sequence]];
  if (result == NSOrderedSame)
    result = [self _compareValue: [self lastModified]
		   withValue: [otherObject lastModified]];

  return result;
}

- (NSComparisonResult) compare: (iCalEntityObject *) otherObject
{
  NSComparisonResult result;

  if ([[self uid] isEqualToString: [otherObject uid]])
    result = [self _compareVersions: otherObject];
  else
    result = [[self created] compare: [otherObject created]];

  return result;
}

@end /* iCalEntityObject */
