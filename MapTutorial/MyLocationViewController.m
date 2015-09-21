//
//  MyLocationViewController.m
//  MapTutorial
//
//  Created by Daniel Distant on 8/16/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import "MyLocationViewController.h"

@interface MyLocationViewController ()

@property (nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeChanger;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveLocationButton;
@property (nonatomic) NSString *savedLocation;

@end

@implementation MyLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"I'm right here!";
    
    [self.mapView addAnnotation:point];
    [self.locationManager stopUpdatingLocation];
}

- (IBAction)refreshButtonTapped:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MyLocationViewController *mylocationviewcontroller = [storyboard instantiateViewControllerWithIdentifier:@"mylocationviewcontroller"];
    
    [self.navigationController pushViewController: mylocationviewcontroller animated:YES];
    
}

- (IBAction)mapTypeChanged:(id)sender {
    
    if (self.mapTypeChanger.selectedSegmentIndex == 0) {
        [self.mapView setMapType:MKMapTypeStandard];
        
    } else if (self.mapTypeChanger.selectedSegmentIndex == 1) {
        [self.mapView setMapType:MKMapTypeSatellite];
        
    } else if (self.mapTypeChanger.selectedSegmentIndex == 2) {
        [self.mapView setMapType:MKMapTypeHybrid];
    }
}
- (IBAction)saveLocationButtonTapped:(id)sender {
    
    UIAlertController *saveLocationAlert = [UIAlertController alertControllerWithTitle:@"Save location" message:@"Where are you right now?" preferredStyle:UIAlertControllerStyleAlert];
    
    [saveLocationAlert addTextFieldWithConfigurationHandler:^(UITextField *saveLocationTextField)
     {
         saveLocationTextField.placeholder = NSLocalizedString(@"Enter place name or address", @"Enter place name or address");
         NSString *text = (NSString *)[saveLocationAlert.textFields objectAtIndex:0].text;
         self.savedLocation = text;
         NSLog(@"Location saved as %@", self.savedLocation);
        
         
     }];
    
    
    [self presentViewController:saveLocationAlert animated:YES completion:nil];
    
    UIAlertAction* logSavedLocation = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *logSavedLocation)
    {
        NSLog(@"Location saved as %@", self.savedLocation);
    }];
    
    [saveLocationAlert addAction:logSavedLocation];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
