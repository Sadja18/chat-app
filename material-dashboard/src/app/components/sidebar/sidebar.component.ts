import { Component, OnInit } from '@angular/core';

declare const $: any;
declare interface RouteInfo {
  path: string;
  title: string;
  icon: string;
  class: string;
}
export const ROUTES: RouteInfo[] = [
  { path: '/dashboard', title: 'Dashboard', icon: 'dashboard', class: '' },
  { path: '/users', title: 'Users Management', icon: 'person', class: '' },
  { path: '/chat-statistics', title: 'Chat Statistics', icon: 'show_chart', class: '' },
  // { path: '/typography', title: 'Typography', icon: 'library_books', class: '' },
  { path: '/profiles', title: 'Profiles Management', icon: 'person_pin', class: '' },
  // { path: '/maps', title: 'Maps', icon: 'location_on', class: '' },
  { path: '/messages', title: 'Chat Management', icon: 'message', class: '' },
  { path: '/notifications', title: 'Notifications', icon: 'notifications', class: '' },

];

@Component({
  selector: 'app-sidebar',
  templateUrl: './sidebar.component.html',
  styleUrls: ['./sidebar.component.css']
})
export class SidebarComponent implements OnInit {
  menuItems: any[];

  constructor() { }

  ngOnInit() {
    this.menuItems = ROUTES.filter(menuItem => menuItem);
  }
  isMobileMenu() {
    if ($(window).width() > 991) {
      return false;
    }
    return true;
  };
}
