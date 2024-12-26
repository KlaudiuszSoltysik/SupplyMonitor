import './assets/main.css'

import {createApp} from 'vue'
import {createRouter, createWebHistory} from 'vue-router'

import App from './App.vue'
import LoginView from './LoginView.vue'
import HomeView from './HomeView.vue'

const routes = [
    {path: '/', component: LoginView, name: 'Login'},
    {path: '/home', component: HomeView, name: 'Home'},
]

const router = createRouter({
    history: createWebHistory(),
    routes,
})

createApp(App).use(router).mount('#app')
