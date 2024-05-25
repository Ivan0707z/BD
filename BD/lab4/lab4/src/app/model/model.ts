export interface Dinosaur {
  _id?: string;
  username: string;
  email: string;
  password: string;
}

export type ModeType = 'read' | 'update' | 'create' | 'delete';
