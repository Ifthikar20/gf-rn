/**
 * User model - mirrors iOS User struct
 */

export interface User {
  id?: string;
  email: string;
  name: string;
  avatarUrl?: string;
  createdAt?: string;
  isPremium?: boolean;
}

export const getDisplayName = (user: User): string => {
  return user.name?.trim() || user.email;
};

export const getInitials = (user: User): string => {
  const name = user.name || '';
  const components = name.split(' ').filter(Boolean);
  const firstInitial = components[0]?.[0] || '';
  const lastInitial = components.length > 1 ? components[components.length - 1]?.[0] || '' : '';
  return (firstInitial + lastInitial).toUpperCase();
};

export default User;
