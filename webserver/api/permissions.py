from rest_framework.permissions import BasePermission


class IsUnauthenticated(BasePermission):
    def has_permission(self, request, view):
        return not request.user.is_authenticated


class IsAuthenticated(BasePermission):
    def has_permission(self, request, view):
        return request.user.is_authenticated


class IsOrganizationAdmin(BasePermission):
    def has_permission(self, request, view):
        return request.session.get('role') == 'Organization Admin'
